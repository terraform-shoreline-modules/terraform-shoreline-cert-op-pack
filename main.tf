# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these parameters/secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# SHORELINE_URL   - The API url for your shoreline cluster, i.e. "https://<customer>.<region>.api.shoreline-<cluster>.io"
# SHORELINE_TOKEN - The alphanumeric access token for your cluster. (Typically from Okta.)

terraform {
  # Setting 0.13.1 as the minimum version. Older versions are missing significant features.
  required_version = ">= 0.13.1"

  #required_providers {
  #  shoreline = {
  #    source  = "shorelinesoftware/shoreline"
  #    version = ">= 1.1.0"
  #  }
  #}
}

# Example instantiation of the Certs OpPack:
module "certs_example" {
  source         = "./modules/certs/"
  prefix         = "example_"
  check_interval = 10
  cert_test_url  = "certs-demo.default"
  port           = 443
  min_cert_days  = 20

  auto_remediate = true

  certbot_force_renew = false
  certbot_use_sudo    = false
  certbot_executable  = "./refresh-cert.sh"
  certbot_flags       = 40
  resource_query      = "pods | app='certs-test'"
  cert_script_path    = "/home"
}
