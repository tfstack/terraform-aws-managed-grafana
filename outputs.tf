output "workspace_id" {
  description = "Identifier of the workspace."
  value       = module.workspace_core.workspace_id
}

output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace."
  value       = module.workspace_core.workspace_arn
}

output "workspace_endpoint" {
  description = "Endpoint URL of the Grafana workspace."
  value       = module.workspace_core.workspace_endpoint
}

output "workspace_grafana_version" {
  description = "Grafana version of the workspace."
  value       = module.workspace_core.workspace_grafana_version
}

output "workspace_role_arn" {
  description = "IAM role ARN used by the workspace to access AWS data sources."
  value       = module.workspace_core.workspace_role_arn
}

output "workspace_api_keys" {
  description = "Workspace API keys created including their attributes."
  value       = module.workspace_content.workspace_api_keys
  sensitive   = true
}

output "workspace_service_accounts" {
  description = "Workspace service accounts created including their attributes."
  value       = module.workspace_content.workspace_service_accounts
}

output "workspace_service_account_tokens" {
  description = "Workspace service account tokens created including their attributes."
  value       = module.workspace_content.workspace_service_account_tokens
  sensitive   = true
}

