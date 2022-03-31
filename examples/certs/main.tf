terraform {
  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.1.3"
    }
  }
}

provider "shoreline" {
  # provider configuration here
  debug   = true
  retries = 2
}

module "certs" {
  # Location of the module
  source         = "terraform-shoreline-modules/cert-op-pack/shoreline//modules/certs"

  # Prefix to allow multiple instances of the module, with different params
  prefix         = "example_"

  # Frequency to evaluate alarm conditions in seconds
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
