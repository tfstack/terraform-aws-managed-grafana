mock_provider "aws" {
  mock_data "aws_partition" {
    defaults = {
      partition = "aws"
    }
  }

  mock_resource "aws_iam_role" {
    defaults = {
      arn  = "arn:aws:iam::123456789012:role/managed-grafana-workspace-role"
      name = "managed-grafana-workspace-role"
    }
  }

  mock_resource "aws_grafana_workspace" {
    defaults = {
      id       = "g-mockworkspace"
      arn      = "arn:aws:grafana:ap-southeast-2:123456789012:/workspaces/g-mockworkspace"
      endpoint = "g-mockworkspace.grafana-workspace.ap-southeast-2.amazonaws.com"
    }
  }
}

run "plan_basic" {
  command = plan

  variables {
    name                     = "amg-basic"
    description              = "amg basic"
    authentication_providers = ["AWS_SSO"]
    data_sources             = ["PROMETHEUS"]
    role_associations = {
      VIEWER = {
        group_ids = ["11111111-2222-3333-4444-555555555555"]
      }
    }
  }

  assert {
    condition     = var.name == "amg-basic"
    error_message = "name should be passed through"
  }
}

run "plan_existing_workspace_passthrough" {
  command = plan

  variables {
    workspace_id     = "g-abc123existing"
    create_workspace = false
  }

  assert {
    condition     = output.workspace_id == "g-abc123existing"
    error_message = "workspace_id should pass through when create_workspace is false."
  }
}

