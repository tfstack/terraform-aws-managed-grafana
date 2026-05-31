provider "aws" {
  region = "ap-southeast-2"
}

module "managed_grafana" {
  source = "../.."

  name        = "managed-grafana-basic"
  description = "Basic AMG workspace example."

  authentication_providers = ["AWS_SSO"]
  data_sources             = ["PROMETHEUS"]
  grafana_version          = "12.4"

  role_associations = {
    VIEWER = {
      user_ids = [var.viewer_user_id]
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

