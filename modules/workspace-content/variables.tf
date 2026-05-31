variable "create_content" {
  description = "Determines whether content resources should be created."
  type        = bool
  default     = true
}

variable "workspace_id" {
  description = "AMG workspace ID to attach content resources to."
  type        = string
}

variable "role_associations" {
  description = "Map of role associations for AWS SSO group/user IDs."
  type = map(object({
    group_ids = optional(list(string), [])
    user_ids  = optional(list(string), [])
  }))
  default = {}
}

variable "workspace_api_keys" {
  description = "Map of workspace API key definitions to create."
  type = map(object({
    key_name        = string
    key_role        = string
    seconds_to_live = number
  }))
  default = {}
}

variable "workspace_service_accounts" {
  description = "Map of workspace service account definitions to create."
  type = map(object({
    name = string
    role = string
  }))
  default = {}
}

variable "workspace_service_account_tokens" {
  description = "Map of workspace service account tokens to create."
  type = map(object({
    service_account_key = string
    name                = string
    seconds_to_live     = number
  }))
  default = {}
}

