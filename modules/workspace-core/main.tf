locals {
  workspace_role_required = (
    var.account_access_type == "CURRENT_ACCOUNT" || var.permission_type == "CUSTOMER_MANAGED"
  )

  create_workspace_iam_role = (
    var.create_workspace && local.workspace_role_required && var.create_iam_role
  )
}

locals {
  default_workspace_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = contains(var.data_sources, "PROMETHEUS") ? [{
      Sid    = "AmazonManagedPrometheusQuery"
      Effect = "Allow"
      Action = [
        "aps:ListWorkspaces",
        "aps:DescribeWorkspace",
        "aps:QueryMetrics",
        "aps:GetSeries",
        "aps:GetLabels",
        "aps:GetMetricMetadata",
      ]
      Resource = "*"
    }] : []
  })
}

resource "aws_iam_role" "this" {
  count = local.create_workspace_iam_role ? 1 : 0

  name = var.iam_role_name != null && trimspace(var.iam_role_name) != "" ? var.iam_role_name : "managed-grafana-workspace-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "grafana.amazonaws.com"
      }
    }]
  })
  permissions_boundary = var.iam_role_permissions_boundary

  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  count = local.create_workspace_iam_role ? 1 : 0

  name   = "workspace-policy"
  role   = aws_iam_role.this[0].name
  policy = coalesce(var.iam_role_policy_json, local.default_workspace_policy_json)
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.create_workspace_iam_role ? toset(var.iam_role_managed_policy_arns) : toset([])

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

locals {
  effective_role_arn = (
    !local.workspace_role_required ? null : (
      var.create_iam_role
      ? try(aws_iam_role.this[0].arn, null)
      : var.iam_role_arn
    )
  )

  configuration_decoded = var.configuration != null ? jsondecode(var.configuration) : {}

  configuration_merged = merge(
    local.configuration_decoded,
    var.enable_unified_alerting ? {
      unifiedAlerting = merge(
        { enabled = true },
        try(local.configuration_decoded.unifiedAlerting, {})
      )
    } : {},
    var.enable_plugin_admin ? {
      plugins = merge(
        { pluginAdminEnabled = true },
        try(local.configuration_decoded.plugins, {})
      )
    } : {}
  )

  workspace_configuration = length(local.configuration_merged) > 0 ? jsonencode(local.configuration_merged) : null
}

resource "aws_grafana_workspace" "this" {
  count = var.create_workspace ? 1 : 0

  name        = var.name
  description = var.description

  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type
  data_sources             = var.data_sources

  grafana_version = var.grafana_version
  configuration   = local.workspace_configuration

  role_arn = local.effective_role_arn

  tags = var.tags
}

resource "aws_grafana_license_association" "this" {
  count = var.create_workspace && var.associate_license ? 1 : 0

  license_type = var.license_type
  workspace_id = aws_grafana_workspace.this[0].id
}
