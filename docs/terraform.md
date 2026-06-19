## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.51.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_firewall_rule_group_stateful"></a> [network\_firewall\_rule\_group\_stateful](#module\_network\_firewall\_rule\_group\_stateful) | terraform-aws-modules/network-firewall/aws//modules/rule-group | ~> 1.0 |
| <a name="module_network_firewall_rule_group_stateless"></a> [network\_firewall\_rule\_group\_stateless](#module\_network\_firewall\_rule\_group\_stateless) | terraform-aws-modules/network-firewall/aws//modules/rule-group | ~> 1.0 |
| <a name="module_nfw"></a> [nfw](#module\_nfw) | terraform-aws-modules/network-firewall/aws | ~> 2.0 |
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
| <a name="input_create"></a> [create](#input\_create) | Whether to create the Network Firewall and all associated resources. | `bool` | `true` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether to create a new firewall policy. Set to false to reference an existing policy via firewall\_policy\_arn. | `bool` | `true` | no |
| <a name="input_create_policy_resource_policy"></a> [create\_policy\_resource\_policy](#input\_create\_policy\_resource\_policy) | Whether to create a resource-based policy for the firewall policy, enabling cross-account sharing. | `bool` | `false` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | Whether to enable delete protection on the firewall, preventing accidental deletion via the console or API. | `bool` | `true` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_firewall_policy_arn"></a> [firewall\_policy\_arn](#input\_firewall\_policy\_arn) | ARN of an existing firewall policy to attach to the firewall. Only used when create\_policy is false. | `string` | `""` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | Whether to protect the firewall against changes to its associated policy, preventing accidental policy swaps. | `bool` | `true` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging configuration for the Network Firewall. Supports CloudWatch Logs, S3, and Kinesis Firehose destinations. | <pre>object({<br/>    enabled                  = optional(bool, false)<br/>    additional_configuration = optional(any, {})<br/>  })</pre> | <pre>{<br/>  "additional_configuration": {},<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | Firewall policy configuration including stateful, stateless, and resource policy settings. | <pre>object({<br/>    resource = object({<br/>      policy_actions    = optional(list(string), [])<br/>      policy_principals = optional(list(string), [])<br/>    })<br/>    stateful = object({<br/>      default_actions = optional(list(string), [])<br/>      engine_options  = optional(any, {})<br/>    })<br/>    stateless = object({<br/>      custom_action            = optional(any, {})<br/>      default_actions          = optional(list(string), [])<br/>      fragment_default_actions = optional(list(string), [])<br/>    })<br/>  })</pre> | <pre>{<br/>  "resource": {<br/>    "policy_actions": [],<br/>    "policy_principals": []<br/>  },<br/>  "stateful": {<br/>    "default_actions": [],<br/>    "engine_options": {}<br/>  },<br/>  "stateless": {<br/>    "custom_action": {},<br/>    "default_actions": [<br/>      "aws:pass"<br/>    ],<br/>    "fragment_default_actions": [<br/>      "aws:drop"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_stateful_rule_groups"></a> [stateful\_rule\_groups](#input\_stateful\_rule\_groups) | Map of stateful firewall rule group configurations. Each key is a logical name; each value must include a rule\_group attribute. | `any` | `{}` | no |
| <a name="input_stateless_rule_groups"></a> [stateless\_rule\_groups](#input\_stateless\_rule\_groups) | Map of stateless firewall rule group configurations. Each key is a logical name; each value must include rule\_group and priority attributes. | `any` | `{}` | no |
| <a name="input_subnet_change_protection"></a> [subnet\_change\_protection](#input\_subnet\_change\_protection) | Whether to protect the firewall against changes to its subnet associations, preventing accidental subnet modifications. | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs in which to create the firewall endpoints. One subnet per Availability Zone is recommended. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the Network Firewall endpoints will be created. | `string` | n/a | yes |

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
