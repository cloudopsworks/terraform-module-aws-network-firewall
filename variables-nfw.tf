##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# create: true  # (Optional) Whether to create the Network Firewall and all associated resources. Default: true
variable "create" {
  description = "Whether to create the Network Firewall and all associated resources."
  type        = bool
  default     = true
}

# logging:                           # (Optional) Logging configuration for the Network Firewall.
#   enabled: false                   # (Optional) Whether to enable logging. Default: false
#   additional_configuration: {}    # (Optional) Additional logging destination configuration as a map.
#                                   #   Allows specifying extra CloudWatch, S3, or Kinesis Firehose log destinations.
#                                   #   See AWS documentation for supported log_destination_type values:
#                                   #   "CloudWatchLogs" | "S3" | "KinesisDataFirehose"
variable "logging" {
  description = "Logging configuration for the Network Firewall. Supports CloudWatch Logs, S3, and Kinesis Firehose destinations."
  type = object({
    enabled                  = optional(bool, false)
    additional_configuration = optional(any, {})
  })
  default = {
    enabled                  = false
    additional_configuration = {}
  }
}

# create_policy: true  # (Optional) Whether to create a new firewall policy. Set to false to use an existing policy via firewall_policy_arn. Default: true
variable "create_policy" {
  description = "Whether to create a new firewall policy. Set to false to reference an existing policy via firewall_policy_arn."
  type        = bool
  default     = true
}

# create_policy_resource_policy: false  # (Optional) Whether to create a resource-based policy for the firewall policy, enabling cross-account sharing. Default: false
variable "create_policy_resource_policy" {
  description = "Whether to create a resource-based policy for the firewall policy, enabling cross-account sharing."
  type        = bool
  default     = false
}

# delete_protection: true  # (Optional) Whether to enable delete protection on the firewall, preventing accidental deletion. Default: true
variable "delete_protection" {
  description = "Whether to enable delete protection on the firewall, preventing accidental deletion via the console or API."
  type        = bool
  default     = true
}

# policy:                                    # (Optional) Firewall policy configuration.
#   resource:                                # (Optional) Resource-based policy settings for cross-account access.
#     policy_actions: []                     # (Optional) List of IAM actions to allow in the resource policy. Default: []
#     policy_principals: []                  # (Optional) List of IAM principal ARNs granted access via the resource policy. Default: []
#   stateful:                                # (Optional) Stateful inspection engine configuration.
#     default_actions: []                    # (Optional) Default stateful actions applied when no rule matches.
#                                            #   Valid values: "aws:drop_strict" | "aws:drop_established" | "aws:alert_strict" | "aws:alert_established"
#     engine_options: {}                     # (Optional) Stateful engine options map (e.g., rule_order). Default: {}
#   stateless:                               # (Optional) Stateless inspection configuration.
#     custom_action: {}                      # (Optional) Custom stateless action definitions. Default: {}
#     default_actions: ["aws:pass"]          # (Optional) Default stateless actions for non-fragmented packets.
#                                            #   Valid values: "aws:pass" | "aws:drop" | "aws:forward_to_sfe"
#     fragment_default_actions: ["aws:drop"] # (Optional) Default stateless actions for fragmented packets.
#                                            #   Valid values: "aws:pass" | "aws:drop" | "aws:forward_to_sfe"
variable "policy" {
  description = "Firewall policy configuration including stateful, stateless, and resource policy settings."
  type = object({
    resource = object({
      policy_actions    = optional(list(string), [])
      policy_principals = optional(list(string), [])
    })
    stateful = object({
      default_actions = optional(list(string), [])
      engine_options  = optional(any, {})
    })
    stateless = object({
      custom_action            = optional(any, {})
      default_actions          = optional(list(string), [])
      fragment_default_actions = optional(list(string), [])
    })
  })
  default = {
    resource = {
      policy_actions    = []
      policy_principals = []
    }
    stateful = {
      default_actions = []
      engine_options  = {}
    }
    stateless = {
      custom_action            = {}
      default_actions          = ["aws:pass"]
      fragment_default_actions = ["aws:drop"]
    }
  }
}

# firewall_policy_arn: ""  # (Optional) ARN of an existing firewall policy to use. Only applicable when create_policy is false. Default: ""
variable "firewall_policy_arn" {
  description = "ARN of an existing firewall policy to attach to the firewall. Only used when create_policy is false."
  type        = string
  default     = ""
}

# vpc_id: ""  # (Required) The ID of the VPC where the Network Firewall will be deployed.
variable "vpc_id" {
  description = "The ID of the VPC where the Network Firewall endpoints will be created."
  type        = string
}

# subnet_ids:  # (Required) List of subnet IDs in which to place the firewall endpoints (one per AZ recommended).
#   - "subnet-0123456789abcdef0"
variable "subnet_ids" {
  description = "List of subnet IDs in which to create the firewall endpoints. One subnet per Availability Zone is recommended."
  type        = list(string)
}

# firewall_policy_change_protection: true  # (Optional) Whether to prevent changes to the firewall policy association. Default: true
variable "firewall_policy_change_protection" {
  description = "Whether to protect the firewall against changes to its associated policy, preventing accidental policy swaps."
  type        = bool
  default     = true
}

# subnet_change_protection: true  # (Optional) Whether to prevent changes to the firewall subnet associations. Default: true
variable "subnet_change_protection" {
  description = "Whether to protect the firewall against changes to its subnet associations, preventing accidental subnet modifications."
  type        = bool
  default     = true
}

# stateful_rule_groups: {}  # (Optional) Map of stateful rule group configurations keyed by a logical name.
#                           #   Each entry must include a `rule_group` attribute compatible with the
#                           #   terraform-aws-modules/network-firewall/aws//modules/rule-group module.
#                           #   Example:
#                           #     my_group:
#                           #       rule_group:
#                           #         rules_source:
#                           #           stateful_rule: []
variable "stateful_rule_groups" {
  description = "Map of stateful firewall rule group configurations. Each key is a logical name; each value must include a rule_group attribute."
  type        = any
  default     = {}
}

# stateless_rule_groups: {}  # (Optional) Map of stateless rule group configurations keyed by a logical name.
#                            #   Each entry must include a `rule_group` attribute and a `priority` for ordering.
#                            #   Example:
#                            #     my_group:
#                            #       priority: 100
#                            #       rule_group:
#                            #         rules_source:
#                            #           stateless_rules_and_custom_actions:
#                            #             stateless_rule: []
variable "stateless_rule_groups" {
  description = "Map of stateless firewall rule group configurations. Each key is a logical name; each value must include rule_group and priority attributes."
  type        = any
  default     = {}
}
