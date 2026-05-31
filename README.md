# terraform-aws-managed-grafana

Terraform module for [Amazon Managed Grafana](https://docs.aws.amazon.com/grafana/latest/userguide/what-is-Amazon-Managed-Service-Grafana.html) (AMG) workspaces and related control-plane resources.

This module follows tfstack conventions and groups tightly coupled AMG resources into two submodules:

| Submodule | Responsibility |
|-----------|----------------|
| [`workspace-core`](modules/workspace-core) | Workspace lifecycle, IAM role, optional license association, configuration |
| [`workspace-content`](modules/workspace-content) | SSO role associations, API keys, service accounts and tokens |

## Usage

```hcl
module "managed_grafana" {
  source  = "tfstack/managed-grafana/aws"
  version = "~> 0.1"

  name        = "eks-21"
  description = "eks-21 managed grafana"

  authentication_providers = ["AWS_SSO"]
  data_sources             = ["PROMETHEUS"]
  grafana_version          = "12.4"

  role_associations = {
    VIEWER = {
      group_ids = ["11111111-2222-3333-4444-555555555555"]
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

See [`examples/basic`](examples/basic) for a working end-to-end example.

## Behaviour

- Set `create_workspace = false` and provide `workspace_id` to attach role associations, API keys, and service accounts to an existing AMG workspace.
- When `create_iam_role = true` and a workspace IAM role is required (`CURRENT_ACCOUNT` or `CUSTOMER_MANAGED`), the module creates a role with a default inline policy allowing **Amazon Managed Prometheus** query APIs when `PROMETHEUS` is in `data_sources`. Override via `iam_role_policy_json` or attach additional policies with `iam_role_managed_policy_arns`.
- Set `enable_unified_alerting = true` (default) before using Grafana v12; the module merges this into workspace configuration JSON.
- `workspace_endpoint`, `workspace_arn`, and `workspace_grafana_version` are populated when the module creates a new workspace; they are `null` when attaching to an existing workspace by ID.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
