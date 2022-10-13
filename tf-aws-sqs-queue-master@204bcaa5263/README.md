# SQS Queue

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.aws-sqs-cloudwatch-alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sqs_queue.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_cloudformation_export.high_alarm_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.low_alarm_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.medium_alarm_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_kms_key.by_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_id"></a> [application\_id](#input\_application\_id) | Unique identifier for the business/application service. | `string` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the business service, eg UFO | `string` | n/a | yes |
| <a name="input_control_tower"></a> [control\_tower](#input\_control\_tower) | Which Control Tower the deployment is for | `string` | `"cloud-zero"` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Assign custom tags to EC2 instance in addition to default tags | `map(string)` | `empty map` | no |
| <a name="input_data_class"></a> [data\_class](#input\_data\_class) | The data class of the application/stack | `string` | n/a | yes |
| <a name="input_deadletter_queue_name"></a> [deadletter\_queue\_name](#input\_deadletter\_queue\_name) | The name of the deadletter SQS queue. NOTE: if the queue is a DLQ for an SNS topic, this does not need to be provided | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Subdomain associated with the target AWS account. Closely related to business unit's name. (ex. crypto, ccoe) | `string` | n/a | yes |
| <a name="input_enable_redrive_policy"></a> [enable\_redrive\_policy](#input\_enable\_redrive\_policy) | Indicate whether to create a dead letter queue for this SQS queue | `bool` | `true` | no |
| <a name="input_env_code"></a> [env\_code](#input\_env\_code) | A three-letter code for the target environment name (dev\|stg\|prd) | `string` | n/a | yes |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | HTTPS Git URL for the caller module's source code | `string` | n/a | yes |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Alias name of the KMS Key to use for ECR encryption | `string` | n/a | yes |
| <a name="input_managed_by"></a> [managed\_by](#input\_managed\_by) | Specifies the Remedy support group that owns the CI | `string` | `"TEST-Monitoring"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The EID of the owner of the resources in the stack (ie. rprice) | `string` | n/a | yes |
| <a name="input_owner_contact"></a> [owner\_contact](#input\_owner\_contact) | The email of the owner of the resources in the stack.; preferably a PDL | `string` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | A Bitbucket project key name in lowercase (ex. ccoe, altp) | `string` | n/a | yes |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | The name of the SQS queue | `string` | n/a | yes |
| <a name="input_supported_by"></a> [supported\_by](#input\_supported\_by) | Specifies the Remedy support group that receives and troubleshoots the initial ticket of the CI | `string` | `"TEST-Monitoring"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The tier of the application/stack | `string` | `"app"` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the topic if the queue is a DLQ for an SNS topic. NOTE: If this is a basic queue, this does not need to be provided | `string` | `""` | no |
| <a name="input_tu_costcenter"></a> [tu\_costcenter](#input\_tu\_costcenter) | Identifies the cost center that Accounting will use for charge-back , Reference Accounting team for valid values Cloud Costing List | `string` | `""` | no |
| <a name="input_udf_instance_name"></a> [udf\_instance\_name](#input\_udf\_instance\_name) | This is a user defined variable. | `string` | `""` | no |
| <a name="input_udf_product"></a> [udf\_product](#input\_udf\_product) | Name of the product attached to the resource | `string` | `""` | no |
| <a name="input_udf_sub_product"></a> [udf\_sub\_product](#input\_udf\_sub\_product) | Name of the subcomponent of the business service, eg CSPA | `string` | `""` | no |
| <a name="input_daily_backup"></a> [daily\_backup](#input\_daily\_backup) | daily backup schedule | `string` | `"dailybackup1800"` | no |
| <a name="input_allowed_actions"></a> [allowed\_actions](#input\_allowed\_actions) | List of allowed actions to add in the resource policy. If no value sent in this list, SendMessgae action will be set by default | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | SQS Queue ARN |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | SQS Queue URL |
<!-- END_TF_DOCS -->
