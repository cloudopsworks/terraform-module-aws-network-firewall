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
    enabled                  = optional(bool, false)
    additional_configuration = optional(any, {})
  })
  default = {
    enabled                  = false
    additional_configuration = {}
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

variable "route_table_ids" {
  type    = list(string)
  default = []
}

variable "nfw_destination_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "firewall_policy_change_protection" {
  type    = bool
  default = true
}

variable "subnet_change_protection" {
  type    = bool
  default = true
}

variable "stateful_rule_groups" {
  type    = any
  default = {}
}

variable "stateless_rule_groups" {
  type    = any
  default = {}
}