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
  logging_config = var.logging.enabled ? [
    {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.logs[0].name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  ] : []
}

resource "aws_cloudwatch_log_group" "logs" {
  count             = var.logging.enabled ? 1 : 0
  name              = "nfw-logs-${local.system_name}"
  retention_in_days = 7
  tags              = local.all_tags
}

module "nfw" {
  source                                   = "terraform-aws-modules/network-firewall/aws"
  version                                  = "~> 1.0"
  name                                     = "nfw-${local.system_name}"
  create                                   = var.create
  create_logging_configuration             = var.logging.enabled
  logging_configuration_destination_config = local.logging_config
  create_policy                            = var.create_policy
  create_policy_resource_policy            = var.create_policy_resource_policy
  delete_protection                        = var.delete_protection
  firewall_policy_arn                      = var.firewall_policy_arn
  policy_encryption_configuration = {
    key_id = aws_kms_key.this.key_id
    type   = "AWS_OWNED_KMS_KEY"
  }
  policy_name                       = "nfw-pol-${local.system_name}"
  policy_description                = "Network Firewall Policy - nfw-pol-${local.system_name}"
  policy_resource_policy_actions    = var.policy.resource.policy_actions
  policy_resource_policy_principals = var.policy.resource.policy_principals
  policy_stateful_default_actions   = var.policy.stateful.default_actions
  policy_stateful_engine_options    = var.policy.stateful.engine_options
  policy_stateful_rule_group_reference = {
    for k, v in var.stateful_rule_groups :
    k => {
      resource_arn = module.network_firewall_rule_group_stateful[k].arn
      priority       = v.priority
    }
  }
  policy_stateless_custom_action            = var.policy.stateless.custom_action
  policy_stateless_default_actions          = var.policy.stateless.default_actions
  policy_stateless_fragment_default_actions = var.policy.stateless.fragment_default_actions
  policy_stateless_rule_group_reference = {
    for k, v in var.stateless_rule_groups :
    k => {
      resource_arn = module.network_firewall_rule_group_stateless[k].arn
      priority       = v.priority
    }
  }
  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection          = var.subnet_change_protection
  policy_tags                       = local.all_tags
  vpc_id                            = var.vpc_id
  subnet_mapping                    = local.subnet_mappings
  tags                              = local.all_tags
}

# Configuration Encryption
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

# Firewall rule groups
module "network_firewall_rule_group_stateful" {
  for_each    = var.stateful_rule_groups
  source      = "terraform-aws-modules/network-firewall/aws//modules/rule-group"
  version     = "~> 1.0"
  name        = "nfw-sf-${each.key}-${local.system_name}"
  description = "Network Firewall Stateful Rule Group - nfw-sf-${each.key}-${local.system_name}"
  type        = "STATEFUL"
  capacity    = 100
  rule_group  = each.value.rule_group
  # Resource Policy
  create_resource_policy     = true
  attach_resource_policy     = true
  resource_policy_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  tags                       = local.all_tags
}

module "network_firewall_rule_group_stateless" {
  for_each    = var.stateless_rule_groups
  source      = "terraform-aws-modules/network-firewall/aws//modules/rule-group"
  version     = "~> 1.0"
  name        = "nfw-sl-${each.key}-${local.system_name}"
  description = "Network Firewall Stateless Rule Group - nfw-sl-${each.key}-${local.system_name}"
  capacity    = 100
  type        = "STATELESS"

  rule_group = each.value.rule_group

  # Resource Policy
  create_resource_policy     = true
  attach_resource_policy     = true
  resource_policy_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  tags                       = local.all_tags
}