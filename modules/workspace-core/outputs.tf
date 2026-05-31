output "workspace_id" {
  description = "Identifier of the workspace."
  value       = var.create_workspace ? aws_grafana_workspace.this[0].id : var.workspace_id
}

output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace."
  value       = var.create_workspace ? aws_grafana_workspace.this[0].arn : null
}

output "workspace_endpoint" {
  description = "Endpoint URL of the Grafana workspace."
  value       = var.create_workspace ? aws_grafana_workspace.this[0].endpoint : null
}

output "workspace_grafana_version" {
  description = "Grafana version of the workspace."
  value       = var.create_workspace ? aws_grafana_workspace.this[0].grafana_version : null
}

output "workspace_role_arn" {
  description = "IAM role ARN used by the workspace to access AWS data sources."
  value       = local.effective_role_arn
}

