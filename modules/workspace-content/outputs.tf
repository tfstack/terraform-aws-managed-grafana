output "workspace_api_keys" {
  description = "Workspace API keys created including their attributes."
  value       = aws_grafana_workspace_api_key.this
  sensitive   = true
}

output "workspace_service_accounts" {
  description = "Workspace service accounts created including their attributes."
  value       = aws_grafana_workspace_service_account.this
}

output "workspace_service_account_tokens" {
  description = "Workspace service account tokens created including their attributes."
  value       = aws_grafana_workspace_service_account_token.this
  sensitive   = true
}

