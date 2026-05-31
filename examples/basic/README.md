# basic

Basic Amazon Managed Grafana workspace example (AWS SSO + Prometheus datasource enabled).

## Variables

| Name | Description |
|------|-------------|
| `viewer_user_id` | IAM Identity Center user ID granted the `VIEWER` role on the workspace |

Copy [`terraform.tfvars.example`](terraform.tfvars.example) to `terraform.tfvars` and set your user ID before `terraform plan`.

