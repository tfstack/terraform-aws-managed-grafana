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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.63 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workspace_content"></a> [workspace\_content](#module\_workspace\_content) | ./modules/workspace-content | n/a |
| <a name="module_workspace_core"></a> [workspace\_core](#module\_workspace\_core) | ./modules/workspace-core | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | Type of account access for the workspace. Valid values are CURRENT\_ACCOUNT and ORGANIZATION. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_associate_license"></a> [associate\_license](#input\_associate\_license) | Determines whether a license will be associated with the workspace. | `bool` | `false` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | Authentication providers for the workspace. v1 default is AWS\_SSO. | `list(string)` | <pre>[<br/>  "AWS_SSO"<br/>]</pre> | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Optional workspace configuration JSON string. Merged with enable\_unified\_alerting and enable\_plugin\_admin when those are true. | `string` | `null` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | When a workspace role is required (CURRENT\_ACCOUNT or CUSTOMER\_MANAGED), controls whether to create the IAM role or use iam\_role\_arn. | `bool` | `true` | no |
| <a name="input_create_workspace"></a> [create\_workspace](#input\_create\_workspace) | Determines whether an AMG workspace will be created or an existing workspace\_id will be used. | `bool` | `true` | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | Data sources for the workspace. v1 default is PROMETHEUS (AMP). | `list(string)` | <pre>[<br/>  "PROMETHEUS"<br/>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Grafana workspace description. | `string` | `null` | no |
| <a name="input_enable_plugin_admin"></a> [enable\_plugin\_admin](#input\_enable\_plugin\_admin) | Enable Grafana plugin management in the workspace configuration. | `bool` | `false` | no |
| <a name="input_enable_unified_alerting"></a> [enable\_unified\_alerting](#input\_enable\_unified\_alerting) | Enable Grafana unified alerting on the workspace. Required before upgrading to Grafana v12. | `bool` | `true` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Grafana version for the workspace. AWS supported values include 9.4, 10.4, and 12.4. | `string` | `"12.4"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Existing IAM role ARN for the Grafana workspace when create\_iam\_role is false. | `string` | `null` | no |
| <a name="input_iam_role_managed_policy_arns"></a> [iam\_role\_managed\_policy\_arns](#input\_iam\_role\_managed\_policy\_arns) | Managed IAM policy ARNs to attach to the created IAM role. | `list(string)` | `[]` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name for the created IAM role when create\_iam\_role is true. | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | IAM permissions boundary ARN for the created IAM role. | `string` | `null` | no |
| <a name="input_iam_role_policy_json"></a> [iam\_role\_policy\_json](#input\_iam\_role\_policy\_json) | Inline IAM policy JSON to attach to the created IAM role. | `string` | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | License type for the workspace license association. ENTERPRISE or ENTERPRISE\_FREE\_TRIAL. | `string` | `"ENTERPRISE"` | no |
| <a name="input_name"></a> [name](#input\_name) | Grafana workspace name. Required when create\_workspace is true. | `string` | `null` | no |
| <a name="input_permission_type"></a> [permission\_type](#input\_permission\_type) | Permission type for the workspace. SERVICE\_MANAGED or CUSTOMER\_MANAGED. | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_role_associations"></a> [role\_associations](#input\_role\_associations) | Map of role associations for AWS SSO group/user IDs. | <pre>map(object({<br/>    group_ids = optional(list(string), [])<br/>    user_ids  = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to resources. | `map(string)` | `{}` | no |
| <a name="input_workspace_api_keys"></a> [workspace\_api\_keys](#input\_workspace\_api\_keys) | Map of workspace API key definitions to create. | <pre>map(object({<br/>    key_name        = string<br/>    key_role        = string<br/>    seconds_to_live = number<br/>  }))</pre> | `{}` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | ID of an existing AMG workspace to use when create\_workspace is false. | `string` | `""` | no |
| <a name="input_workspace_service_account_tokens"></a> [workspace\_service\_account\_tokens](#input\_workspace\_service\_account\_tokens) | Map of workspace service account tokens to create. | <pre>map(object({<br/>    service_account_key = string<br/>    name                = string<br/>    seconds_to_live     = number<br/>  }))</pre> | `{}` | no |
| <a name="input_workspace_service_accounts"></a> [workspace\_service\_accounts](#input\_workspace\_service\_accounts) | Map of workspace service account definitions to create. | <pre>map(object({<br/>    name = string<br/>    role = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_api_keys"></a> [workspace\_api\_keys](#output\_workspace\_api\_keys) | Workspace API keys created including their attributes. |
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | Amazon Resource Name (ARN) of the workspace. |
| <a name="output_workspace_endpoint"></a> [workspace\_endpoint](#output\_workspace\_endpoint) | Endpoint URL of the Grafana workspace. |
| <a name="output_workspace_grafana_version"></a> [workspace\_grafana\_version](#output\_workspace\_grafana\_version) | Grafana version of the workspace. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Identifier of the workspace. |
| <a name="output_workspace_role_arn"></a> [workspace\_role\_arn](#output\_workspace\_role\_arn) | IAM role ARN used by the workspace to access AWS data sources. |
| <a name="output_workspace_service_account_tokens"></a> [workspace\_service\_account\_tokens](#output\_workspace\_service\_account\_tokens) | Workspace service account tokens created including their attributes. |
| <a name="output_workspace_service_accounts"></a> [workspace\_service\_accounts](#output\_workspace\_service\_accounts) | Workspace service accounts created including their attributes. |
<!-- END_TF_DOCS -->
