module "aws_kms_key" {
  source                 = "/c/Users/bramesh/Express-sns/kms-key.tar.gz"
  kms_key_purpose        = var.kms_key_purpose
  data_class             = var.data_class
  domain                 = var.domain
  env_code               = var.env_code
  git_url                = var.git_url
  owner                  = var.owner
  owner_contact          = var.owner_contact
  project_key            = var.project_key
  udf_sub_product        = var.udf_sub_product
  component_short_name   = var.component_short_name
  udf_product            = var.udf_product
  tu_costcenter          = var.tu_costcenter
  application_id         = var.application_id
  application_name       = var.application_name
  account_principal_arns = var.account_principal_arns
  deployer_role          = var.deployer_role
  custom_tags            = var.custom_tags

  count = var.create_kms_key ? 1 : 0
}

module "aws_sqs_queue" {
  source                = "c/Users/bramesh/Express-sns/sqs-queue.tar.gz"
  queue_name            = local.dlq_name
  enable_redrive_policy = false
  topic_name            = local.topic_canonical_name

  application_id   = var.application_id
  application_name = var.application_name
  data_class       = var.data_class
  domain           = var.domain
  env_code         = var.env_code
  git_url          = var.git_url
  kms_key_alias    = var.kms_key_alias
  kms_key_arn      = var.create_kms_key ? module.aws_kms_key[0].kms_key_arn : local.kms_key_arn
  owner            = var.owner
  owner_contact    = var.owner_contact
  project_key      = var.project_key
  custom_tags      = var.custom_tags
}

resource "aws_sns_topic" "main" {
  depends_on = [
    module.aws_sqs_queue
  ]
  name              = local.topic_canonical_name
  kms_master_key_id = var.create_kms_key ? module.aws_kms_key[0].kms_key_arn : local.kms_key_arn
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "EncryptTransitPolicy"
    Statement = [
      {
        Sid    = "AllowPublishThroughSSLOnly"
        Action = "sns:Publish",
        Effect = "Deny"
        Resource = [
          "${local.topic_name_arn}",
        ],
        Condition = {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
      },
    ]
  })
  tags = local.tags
}

resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "sqs"
  endpoint  = module.aws_sqs_queue.queue_arn

  redrive_policy = jsonencode({
    "deadLetterTargetArn" = "${module.aws_sqs_queue.queue_arn}"
  })
}

resource "aws_cloudwatch_metric_alarm" "aws-sns-cloudwatch-alarm" {
  alarm_actions       = [data.aws_cloudformation_export.low_alarm_sns_topic.value]
  alarm_description   = "Alarm if topic has too many messages published within a timeframe"
  alarm_name          = "${var.project_key}-SNS"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    NumberOfMessagesPublished = aws_sns_topic.main.name
  }
  evaluation_periods = 1
  metric_name        = ""
  namespace          = "AWS/SNS"
  ok_actions         = [data.aws_cloudformation_export.low_alarm_sns_topic.value]
  period             = 300
  statistic          = "Average"
  threshold          = var.cloudwatch_threshold

  tags = local.tags
}