variable "create_workspace" {
  description = "Determines whether an AMG workspace will be created or an existing workspace_id will be used."
  type        = bool
  default     = true
}

variable "workspace_id" {
  description = "ID of an existing AMG workspace to use when create_workspace is false."
  type        = string
  default     = ""
}

variable "name" {
  description = "Grafana workspace name. Required when create_workspace is true."
  type        = string
  default     = null
}

variable "description" {
  description = "Grafana workspace description."
  type        = string
  default     = null
}

variable "account_access_type" {
  description = "Type of account access for the workspace. Valid values are CURRENT_ACCOUNT and ORGANIZATION."
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "authentication_providers" {
  description = "Authentication providers for the workspace. v1 default is AWS_SSO."
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "permission_type" {
  description = "Permission type for the workspace. SERVICE_MANAGED or CUSTOMER_MANAGED."
  type        = string
  default     = "SERVICE_MANAGED"
}

variable "data_sources" {
  description = "Data sources for the workspace. v1 default is PROMETHEUS (AMP)."
  type        = list(string)
  default     = ["PROMETHEUS"]
}

variable "grafana_version" {
  description = "Grafana version for the workspace. AWS supported values include 9.4, 10.4, and 12.4."
  type        = string
  default     = "12.4"
}

variable "enable_unified_alerting" {
  description = "Enable Grafana unified alerting on the workspace. Required before upgrading to Grafana v12."
  type        = bool
  default     = true
}

variable "enable_plugin_admin" {
  description = "Enable Grafana plugin management in the workspace configuration."
  type        = bool
  default     = false
}

variable "configuration" {
  description = "Optional workspace configuration JSON string. Merged with enable_unified_alerting and enable_plugin_admin when those are true."
  type        = string
  default     = null
}

variable "create_iam_role" {
  description = "When a workspace role is required (CURRENT_ACCOUNT or CUSTOMER_MANAGED), controls whether to create the IAM role or use iam_role_arn."
  type        = bool
  default     = true
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for the Grafana workspace when create_iam_role is false."
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "Name for the created IAM role when create_iam_role is true."
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "IAM permissions boundary ARN for the created IAM role."
  type        = string
  default     = null
}

variable "iam_role_policy_json" {
  description = "Inline IAM policy JSON to attach to the created IAM role."
  type        = string
  default     = null
}

variable "iam_role_managed_policy_arns" {
  description = "Managed IAM policy ARNs to attach to the created IAM role."
  type        = list(string)
  default     = []
}

variable "associate_license" {
  description = "Determines whether a license will be associated with the workspace."
  type        = bool
  default     = false
}

variable "license_type" {
  description = "License type for the workspace license association. ENTERPRISE or ENTERPRISE_FREE_TRIAL."
  type        = string
  default     = "ENTERPRISE"
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

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}

