##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  subnet_mappings = {
    for sub in var.subnet_ids : "subnet-${sub}" => {
      subnet_id       = sub
      ip_address_type = "IPV4"
    }
  }
}

module "nfw" {
  source                                   = "terraform-aws-modules/network-firewall/aws"
  version                                  = "~> 1.0"
  name                                     = "nfw-${local.system_name}"
  create                                   = var.create
  create_logging_configuration             = var.logging.enabled
  logging_configuration_destination_config = var.logging.configurations
  create_policy                            = var.create_policy
  create_policy_resource_policy            = var.create_policy_resource_policy
  delete_protection                        = var.delete_protection
  firewall_policy_arn                      = var.firewall_policy_arn
  policy_encryption_configuration = {
    key_id = aws_kms_key.this.key_id
    type   = "AWS_OWNED_KMS_KEY"
  }
  policy_name                               = "nfw-pol-${local.system_name}"
  policy_description                        = "Network Firewall Policy - nfw-pol-${local.system_name}"
  policy_resource_policy_actions            = var.policy.resource.policy_actions
  policy_resource_policy_principals         = var.policy.resource.policy_principals
  policy_stateful_default_actions           = var.policy.stateful.default_actions
  policy_stateful_engine_options            = var.policy.stateful.engine_options
  policy_stateful_rule_group_reference      = var.policy.stateful.rule_group_reference
  policy_stateless_custom_action            = var.policy.stateless.custom_action
  policy_stateless_default_actions          = var.policy.stateless.default_actions
  policy_stateless_fragment_default_actions = var.policy.stateless.fragment_default_actions
  policy_stateless_rule_group_reference     = var.policy.stateless.rule_group_reference
  firewall_policy_change_protection         = var.firewall_policy_change_protection
  subnet_change_protection                  = var.subnet_change_protection
  policy_tags                               = local.all_tags
  vpc_id                                    = var.vpc_id
  subnet_mapping                            = local.subnet_mappings
  tags                                      = local.all_tags
}

resource "aws_kms_key" "this" {
  description             = "KMS key for Network Firewall Policy - ${local.system_name}"
  deletion_window_in_days = 10
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true

  tags = merge({
    name = "nfw-kms-${local.system_name}"
  }, local.all_tags)
}

resource "aws_kms_alias" "this" {
  name          = "alias/nfw-kms-${local.system_name}"
  target_key_id = aws_kms_key.this.key_id
}