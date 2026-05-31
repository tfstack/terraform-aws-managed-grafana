resource "aws_grafana_role_association" "this" {
  for_each = var.create_content ? var.role_associations : {}

  workspace_id = var.workspace_id
  role         = each.key
  group_ids    = try(each.value.group_ids, [])
  user_ids     = try(each.value.user_ids, [])
}

resource "aws_grafana_workspace_api_key" "this" {
  for_each = var.create_content ? var.workspace_api_keys : {}

  workspace_id    = var.workspace_id
  key_name        = each.value.key_name
  key_role        = each.value.key_role
  seconds_to_live = each.value.seconds_to_live
}

resource "aws_grafana_workspace_service_account" "this" {
  for_each = var.create_content ? var.workspace_service_accounts : {}

  workspace_id = var.workspace_id
  name         = each.value.name
  grafana_role = each.value.role
}

resource "aws_grafana_workspace_service_account_token" "this" {
  for_each = var.create_content ? var.workspace_service_account_tokens : {}

  workspace_id       = var.workspace_id
  name               = each.value.name
  seconds_to_live    = each.value.seconds_to_live
  service_account_id = aws_grafana_workspace_service_account.this[each.value.service_account_key].service_account_id
}

