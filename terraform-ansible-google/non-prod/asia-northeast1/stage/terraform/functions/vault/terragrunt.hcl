

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/vault-gcp-demo-module//gcp_vault?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../../terragrunt.hcl"
}

dependency "vpc" {
  config_path = "../../vpc"

  mock_outputs = {
    network             = "networkName"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}
dependency "f5" {
  config_path = "../f5"

  mock_outputs = {
    f5_private_ip   = "2.2.2.2"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix                  = "demo-vault"
  project_id                   = "f5-gcs-4261-sales-apcj-japan"
  region                       = "asia-northeast1"
  zone                         = "asia-northeast1-b"
  storage_bucket_name          = "tky-drone-vault1"
  network                      = dependency.vpc.outputs.network
  f5_vault_addr                = dependency.f5.outputs.f5_private_ip
  kms_keyring                  = "vault7"
  vault_machine_type           = "n1-standard-1"
  consul_version               = "1.8.0"
  app_tag_value                = "terrydemo"
}