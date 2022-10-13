application_id          = "tf-module"
application_name        = "emonz"
env_code                = "dev"
project_key             = "devtools"
domain                  = "dtiac"
owner_contact           = "PDL_Enterprise_Monitoring@transunion.com"
owner                   = "kkearne"
managed_by              = "Enterprise Monitoring - Zenoss/SCOM"
supported_by            = "Enterprise Monitoring - Zenoss/SCOM"
control_tower           = "cloud-plus"
tier                    = "app"
git_url                 = "https://git.transunion.com/projects/TFMOD/repos/tf-aws-sqs-queue.git"
data_class              = "Internal"
kms_key_alias           = "alias/devtools-sqs-queue"
tu_costcenter           = "8766"
custom_tags             = {"tu:ct_key" = "ct_value"}

#basic queue: devtools-dtiac with DLQ of: devtools-dtiac-dlq
queue_name              = "devtools-dtiac"
enable_redrive_policy   = true
deadletter_queue_name   = "devtools-dtiac-dlq"

#DLQ: devtools-dtiac-sns-dlq for SNS topic: devtools-dtiac-sns
#queue_name              = "devtools-dtiac-sns-dlq"
#topic_name              = "devtools-dtiac-sns"
#enable_redrive_policy   = false
