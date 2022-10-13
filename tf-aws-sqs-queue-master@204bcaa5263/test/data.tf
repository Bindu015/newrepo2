data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_cloudformation_export" "low_alarm_sns_topic" {
  name = "emonz-incident-prod-low"
}

data "aws_cloudformation_export" "medium_alarm_sns_topic" {
  name = "emonz-incident-prod-medium"
}

data "aws_cloudformation_export" "high_alarm_sns_topic" {
  name = "emonz-incident-prod-high"
}

data "aws_kms_key" "by_alias" {
  count = length(var.kms_key_alias) > 0 ? 1 : 0
  key_id = var.kms_key_alias
}
