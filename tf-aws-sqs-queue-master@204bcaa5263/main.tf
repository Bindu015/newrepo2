resource "aws_sqs_queue" "main" {
  name              = var.queue_name
  kms_master_key_id = local.kms_key_arn

  # if the queue is a basic queue (has a DLQ), then only need 
  # EncryptTransitPolicy.  However, if the queue is a DLQ for
  # SNS topic, then need both the EncryptTransitPolicy and 
  # AllowDLQFromSNS
  policy = var.enable_redrive_policy ? jsonencode({
    Version = "2012-10-17"
    Id      = "EncryptTransitPolicy"
    Statement = [
      {
        Sid    = "AllowActionsThroughSSLOnly"
        Action = "${local.allowed_actions}",
        Effect = "Deny"
        Resource = [
          "${local.queue_name_arn}",
        ],
        Condition = {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        Principal = {
          AWS = "${local.account_principal_arns_str}"
        }
      }
    ]
    }) : jsonencode({
    Version = "2012-10-17"
    Id      = "EncryptTransitPolicy"
    Statement = [
      {
        Sid    = "AllowActionsThroughSSLOnly"
        Action = "${local.allowed_actions}",
        Effect = "Deny"
        Resource = [
          "${local.queue_name_arn}",
        ],
        Condition = {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        Principal = {
          AWS = "${local.account_principal_arns_str}"
        }
      },
      {
        Sid    = "AllowDLQFromSNS"
        Action = "sqs:SendMessage",
        Effect = "Allow"
        Resource = [
          "${local.queue_name_arn}",
        ],
        Condition = {
          "Bool" : {
            "aws:SourceArn" : "${local.topic_name_arn}"
          }
        },
        Principal = {
          Service = "sns.amazonaws.com"
        }
      },
    ]
  })

  redrive_policy = var.enable_redrive_policy ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.aws-sqs-deadletter_queue[0].arn
    maxReceiveCount     = 4
  }) : null

  redrive_allow_policy = var.enable_redrive_policy ? jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.aws-sqs-deadletter_queue[0].arn]
  }) : null

  tags = local.tags
}

resource "aws_sqs_queue" "aws-sqs-deadletter_queue" {
  count             = var.enable_redrive_policy ? 1 : 0
  name              = var.deadletter_queue_name
  kms_master_key_id = local.kms_key_arn
  tags              = local.tags
}

resource "aws_cloudwatch_metric_alarm" "aws-sqs-cloudwatch-alarm" {
  alarm_actions       = [data.aws_cloudformation_export.high_alarm_sns_topic.value]
  alarm_description   = "Alarm if approximate age of the oldest non-deleted message in the queue is greater than 900 seconds"
  alarm_name          = "${var.project_key}-sqs"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    ApproximateAgeOfOldestMessage = aws_sqs_queue.main.name
  }
  evaluation_periods = 1
  metric_name        = "ApproximateAgeOfOldestMessage"
  namespace          = "AWS/SQS"
  ok_actions         = [data.aws_cloudformation_export.high_alarm_sns_topic.value]
  period             = 300
  statistic          = "Average"
  threshold          = 900

  tags = local.tags
}