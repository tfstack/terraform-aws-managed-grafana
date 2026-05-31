variable "create_workspace" {
  description = "Determines whether an AMG workspace will be created or an existing workspace_id will be used."
  type        = bool
  default     = true
}

variable "workspace_id" {
  description = "Existing workspace ID to use when create_workspace is false."
  type        = string
  default     = ""
}

variable "name" {
  description = "Grafana workspace name."
  type        = string
  default     = null
}

variable "description" {
  description = "Grafana workspace description."
  type        = string
  default     = null
}

variable "account_access_type" {
  description = "Type of account access for the workspace."
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "authentication_providers" {
  description = "Authentication providers for the workspace."
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "permission_type" {
  description = "Permission type for the workspace."
  type        = string
  default     = "SERVICE_MANAGED"
}

variable "data_sources" {
  description = "Data sources for the workspace."
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

  validation {
    condition = (
      !var.create_workspace
      || !(
        var.account_access_type == "CURRENT_ACCOUNT"
        || var.permission_type == "CUSTOMER_MANAGED"
      )
      || var.create_iam_role
      || (var.iam_role_arn != null && trimspace(var.iam_role_arn) != "")
    )
    error_message = "iam_role_arn must be provided when create_iam_role is false and a workspace IAM role is required."
  }
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
  description = "License type for the workspace license association."
  type        = string
  default     = "ENTERPRISE"
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}

