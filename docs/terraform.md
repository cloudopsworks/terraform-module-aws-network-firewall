## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_firewall_rule_group_stateful"></a> [network\_firewall\_rule\_group\_stateful](#module\_network\_firewall\_rule\_group\_stateful) | terraform-aws-modules/network-firewall/aws//modules/rule-group | ~> 1.0 |
| <a name="module_network_firewall_rule_group_stateless"></a> [network\_firewall\_rule\_group\_stateless](#module\_network\_firewall\_rule\_group\_stateless) | terraform-aws-modules/network-firewall/aws//modules/rule-group | ~> 1.0 |
| <a name="module_nfw"></a> [nfw](#module\_nfw) | terraform-aws-modules/network-firewall/aws | ~> 1.0 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | n/a | `bool` | `true` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_policy_resource_policy"></a> [create\_policy\_resource\_policy](#input\_create\_policy\_resource\_policy) | n/a | `bool` | `false` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | n/a | `bool` | `true` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_firewall_policy_arn"></a> [firewall\_policy\_arn](#input\_firewall\_policy\_arn) | n/a | `string` | `""` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | n/a | `bool` | `true` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | n/a | <pre>object({<br/>    enabled                  = optional(bool, false)<br/>    additional_configuration = optional(any, {})<br/>  })</pre> | <pre>{<br/>  "additional_configuration": {},<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | n/a | <pre>object({<br/>    resource = object({<br/>      policy_actions    = optional(list(string), [])<br/>      policy_principals = optional(list(string), [])<br/>    })<br/>    stateful = object({<br/>      default_actions = optional(list(string), [])<br/>      engine_options  = optional(any, {})<br/>    })<br/>    stateless = object({<br/>      custom_action            = optional(any, {})<br/>      default_actions          = optional(list(string), [])<br/>      fragment_default_actions = optional(list(string), [])<br/>    })<br/>  })</pre> | <pre>{<br/>  "resource": {<br/>    "policy_actions": [],<br/>    "policy_principals": []<br/>  },<br/>  "stateful": {<br/>    "default_actions": [],<br/>    "engine_options": {}<br/>  },<br/>  "stateless": {<br/>    "custom_action": {},<br/>    "default_actions": [<br/>      "aws:pass"<br/>    ],<br/>    "fragment_default_actions": [<br/>      "aws:drop"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |
| <a name="input_stateful_rule_groups"></a> [stateful\_rule\_groups](#input\_stateful\_rule\_groups) | n/a | `any` | `{}` | no |
| <a name="input_stateless_rule_groups"></a> [stateless\_rule\_groups](#input\_stateless\_rule\_groups) | n/a | `any` | `{}` | no |
| <a name="input_subnet_change_protection"></a> [subnet\_change\_protection](#input\_subnet\_change\_protection) | n/a | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | n/a |
| <a name="output_firewall_kms_key_alias"></a> [firewall\_kms\_key\_alias](#output\_firewall\_kms\_key\_alias) | n/a |
| <a name="output_firewall_kms_key_id"></a> [firewall\_kms\_key\_id](#output\_firewall\_kms\_key\_id) | n/a |
| <a name="output_firewall_status"></a> [firewall\_status](#output\_firewall\_status) | n/a |
| <a name="output_logging_configuration_id"></a> [logging\_configuration\_id](#output\_logging\_configuration\_id) | n/a |
| <a name="output_nfw_rule_groups_stateful"></a> [nfw\_rule\_groups\_stateful](#output\_nfw\_rule\_groups\_stateful) | n/a |
| <a name="output_nfw_rule_groups_stateless"></a> [nfw\_rule\_groups\_stateless](#output\_nfw\_rule\_groups\_stateless) | n/a |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | n/a |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | n/a |
| <a name="output_policy_update_token"></a> [policy\_update\_token](#output\_policy\_update\_token) | n/a |
| <a name="output_update_token"></a> [update\_token](#output\_update\_token) | n/a |
