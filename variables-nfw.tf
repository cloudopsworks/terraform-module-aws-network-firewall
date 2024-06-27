##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "create" {
  type    = bool
  default = true
}

variable "logging" {
  type = object({
    enabled        = optional(bool, false)
    configurations = optional(any, [])
  })
  default = {
    enabled        = false
    configurations = []
  }
}

variable "create_policy" {
  type    = bool
  default = true
}

variable "create_policy_resource_policy" {
  type    = bool
  default = false
}

variable "delete_protection" {
  type    = bool
  default = true
}

variable "policy" {
  type = object({
    resource = object({
      policy_actions    = optional(list(string), [])
      policy_principals = optional(list(string), [])
    })
    stateful = object({
      default_actions      = optional(list(string), [])
      engine_options       = optional(any, {})
      rule_group_reference = optional(any, {})
    })
    stateless = object({
      custom_action            = optional(any, {})
      default_actions          = optional(list(string), [])
      fragment_default_actions = optional(list(string), [])
      rule_group_reference     = optional(any, {})
    })
  })
  default = {
    resource = {
      policy_actions    = []
      policy_principals = []
    }
    stateful = {
      default_actions      = []
      engine_options       = {}
      rule_group_reference = {}
    }
    stateless = {
      custom_action            = {}
      default_actions          = ["aws:pass"]
      fragment_default_actions = ["aws:drop"]
      rule_group_reference     = {}
    }
  }
}

variable "firewall_policy_arn" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "firewall_policy_change_protection" {
  type    = bool
  default = true
}

variable "subnet_change_protection" {
  type    = bool
  default = true
}