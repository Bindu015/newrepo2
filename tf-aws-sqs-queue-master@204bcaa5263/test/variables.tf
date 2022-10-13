variable "application_id" {
  description = "Unique identifier for the business/application service."
  type        = string
}

variable "application_name" {
  description = "Name of the business service, eg UFO"
  type        = string
}

variable "custom_tags" {
  description = "Custom tags to specify by application team"
  type        = map(string)
  default     = {}
}

variable "deadletter_queue_name" {
  description = "The name of the deadletter SQS queue"
  type        = string
  default     = ""
}

variable "enable_redrive_policy" {
  description = "Indicate whether to create a dead letter queue for this SQS queue"
  type        = bool
  default     = true
}

variable "env_code" {
  description = "A three-letter code for the target environment name (dev|stg|prd)"
  type        = string
  validation {
    condition     = can(regex("^(dev|stg|prd)$", var.env_code))
    error_message = "Must be one of 'dev', 'stg', or 'prd'."
  }
}

variable "project_key" {
  description = "A Bitbucket project key name in lowercase (ex. ccoe, altp)"
  type        = string
  validation {
    condition     = length(var.project_key) >= 2 && can(regex("[a-z]+", var.project_key))
    error_message = "Must contain only lowercase letters, and be two or more characters."
  }
}

variable "domain" {
  description = "Subdomain associated with the target AWS account. Closely related to business unit's name. (ex. crypto, ccoe)"
  type        = string
  validation {
    condition     = length(var.domain) >= 2 && length(var.domain) <= 253 && can(regex("[a-z]+", var.domain))
    error_message = "Must contain only lowercase letters, and be between 2 and 253 characters."
  }
}

variable "owner" {
  description = "The EID of the owner of the resources in the stack (ie. rprice)"
  type        = string
}

variable "owner_contact" {
  description = "The email of the owner of the resources in the stack.; preferably a PDL"
  type        = string
}

variable "managed_by" {
  description = "Specifies the Remedy support group that owns the CI"
  type        = string
  default     = "TEST-Monitoring"
}

variable "supported_by" {
  description = "Specifies the Remedy support group that receives and troubleshoots the initial ticket of the CI"
  type        = string
  default     = "TEST-Monitoring"
}

variable "control_tower" {
  description = "Which Control Tower the deployment is for"
  type        = string
  default     = "cloud-zero"
  validation {
    condition     = can(regex("^cloud-(zero|plus)$", var.control_tower))
    error_message = "Must be one of 'cloud-zero' or 'cloud-plus'."
  }
}

variable "tier" {
  description = "The tier of the application/stack"
  type        = string
  default     = "app"
  validation {
    condition     = can(regex("^(app|dmz|data|comsvs|infra)$", var.tier))
    error_message = "Must be one of the allowed values."
  }
}

variable "git_url" {
  description = "HTTPS Git URL for the caller module's source code"
  type        = string
}

variable "data_class" {
  description = "The data class of the application/stack"
  type        = string
  validation {
    condition     = can(regex("^(Internal|Public|Confidential|Restricted)$", var.data_class))
    error_message = "Must be one of the allowed values."
  }
}

variable "kms_key_alias" {
  description = "Alias name of the KMS Key to use for ECR encryption"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "ARN of the KMS Key to use for ECR encryption"
  type        = string
  default     = ""
}

variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "topic_name" {
  description = "If the queue is to be a DLQ for an SNS topic, the name of the SNS topic"
  type        = string
  default     = ""
}

variable "udf_instance_name" {
  description = "This is a user defined variable."
  type        = string
  default     = ""
}

variable "tu_costcenter" {
  description = "Identifies the cost center that Accounting will use for charge-back , Reference Accounting team for valid values Cloud Costing List"
  type        = string
  default     = ""
}

variable "udf_product" {
  description = "Name of the product attached to the resource"
  type        = string
  default     = ""
}

variable "udf_sub_product" {
  description = "Name of the subcomponent of the business service, eg CSPA"
  type        = string
  default     = ""
}

locals {
  account_id     = data.aws_caller_identity.current.account_id

  kms_key_arn    =  length(var.kms_key_arn) > 0 ? var.kms_key_arn : data.aws_kms_key.by_alias[0].arn

  queue_name_arn = "arn:aws:sqs:${data.aws_region.current.name}:${local.account_id}:${var.queue_name}"
  topic_name_arn = "arn:aws:sns:${data.aws_region.current.name}:${local.account_id}:${var.topic_name}"
  
  udf_product = length(var.udf_product) > 0 ? var.udf_product : length(var.udf_instance_name) > 0 ? var.udf_instance_name : var.project_key
  udf_sub_product =length(var.udf_sub_product) > 0 ? var.udf_sub_product : length(var.udf_instance_name) > 0 ? var.udf_instance_name : var.project_key

  tags = merge({
    "tu:application_id"               = var.application_id
    "tu:application_name"             = var.application_name
    "tu:dataclassification"           = var.data_class
    "tu:env"                          = var.env_code
    "tu:giturl"                       = var.git_url
    "tu:managed_by"                   = var.managed_by
    "tu:owner-contact"                = var.owner_contact
    "tu:owner"                        = var.owner
    "tu:product"                      = local.udf_product
    "tu:sub-product"                  = local.udf_sub_product
    "tu:supported_by"                 = var.supported_by
    "tu:tier"                         = var.tier
    "tu:unit"                         = var.domain
    "tu:costcenter"                   = var.tu_costcenter
  }, var.custom_tags)
}

