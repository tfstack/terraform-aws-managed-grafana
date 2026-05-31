module "workspace_core" {
  source = "./modules/workspace-core"

  create_workspace = var.create_workspace
  workspace_id     = var.workspace_id

  name        = var.name
  description = var.description

  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type
  data_sources             = var.data_sources
  grafana_version          = var.grafana_version
  enable_unified_alerting  = var.enable_unified_alerting
  enable_plugin_admin      = var.enable_plugin_admin
  configuration            = var.configuration

  create_iam_role               = var.create_iam_role
  iam_role_arn                  = var.iam_role_arn
  iam_role_name                 = var.iam_role_name
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_json          = var.iam_role_policy_json
  iam_role_managed_policy_arns  = var.iam_role_managed_policy_arns

  associate_license = var.associate_license
  license_type      = var.license_type

  tags = var.tags
}

module "workspace_content" {
  source = "./modules/workspace-content"

  create_content = var.create_workspace || trimspace(var.workspace_id) != ""
  workspace_id   = module.workspace_core.workspace_id

  role_associations = var.role_associations

  workspace_api_keys = var.workspace_api_keys

  workspace_service_accounts       = var.workspace_service_accounts
  workspace_service_account_tokens = var.workspace_service_account_tokens
}

