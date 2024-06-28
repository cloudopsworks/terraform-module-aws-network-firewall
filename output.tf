##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "firewall_status" {
  value = module.nfw.status
}

output "firewall_arn" {
  value = module.nfw.arn
}

output "policy_arn" {
  value = module.nfw.policy_arn
}

output "policy_id" {
  value = module.nfw.policy_id
}

output "logging_configuration_id" {
  value = module.nfw.logging_configuration_id
}

output "update_token" {
  value     = module.nfw.update_token
  sensitive = true
}

output "policy_update_token" {
  value     = module.nfw.policy_update_token
  sensitive = true
}

output "firewall_kms_key_id" {
  value = aws_kms_key.this.id
}

output "firewall_kms_key_alias" {
  value = aws_kms_alias.this.name
}

output "nfw_rule_groups_stateful" {
  value = {
    for k, v in module.network_firewall_rule_group_stateful : k => {
      arn          = v.arn
      update_token = v.update_token
    }
  }
}

output "nfw_rule_groups_stateless" {
  value = {
    for k, v in module.network_firewall_rule_group_stateless : k => {
      arn          = v.arn
      update_token = v.update_token
    }
  }
}