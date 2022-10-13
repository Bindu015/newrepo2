module "test" {
    source = "../" 

    application_name                        = var.application_name
    application_id                          = var.application_id
    env_code                                = var.env_code
    project_key                             = var.project_key
    domain                                  = var.domain
    owner                                   = var.owner
    owner_contact                           = var.owner_contact
    managed_by                              = var.managed_by
    supported_by                            = var.supported_by
    tier                                    = var.tier
    git_url                                 = var.git_url
    data_class                              = var.data_class
    kms_key_alias	                        = var.kms_key_alias
    queue_name                              = var.queue_name
    deadletter_queue_name                   = var.deadletter_queue_name
    tu_costcenter                           = var.tu_costcenter
}
