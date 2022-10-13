output "queue_arn" {
  description = "SQS Queue ARN"
  value       = aws_sqs_queue.main.arn
}

output "queue_url" {
  description = "SQS Queue URL"
  value       = aws_sqs_queue.main.url
}
