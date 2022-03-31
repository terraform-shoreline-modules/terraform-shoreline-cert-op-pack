terraform {
  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.1.0"
    }
  }
}

locals {
  prefix = "cicerts_"
}

module "cert_check" {
  source         = "../"
  prefix         = "cicerts_"
  # check more frequently to speed up test
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
}

# Push the web server file
resource "shoreline_file" "cert_check_webserver_file" {
  name             = "${local.prefix}cert_check_webserver_script"
  description      = "Python web server."
  input_file       = "${path.module}/test-container/main.py"
  destination_path = "/main.py"
  resource_query   = "pods | app='certs-test'"

  enabled = true
}

# Push the script that starts the webserver
resource "shoreline_file" "cert_check_start_webserver_file" {
  name             = "${local.prefix}cert_check_start_webserver_script"
  description      = "Starts the python web server."
  input_file       = "${path.module}/test-container/start-webserver.sh"
  destination_path = "/start-webserver.sh"
  resource_query   = "pods | app='certs-test'"

  enabled = true
}

# Push the script that refreshes the certificate
resource "shoreline_file" "cert_check_refresh_cert_file" {
  name             = "${local.prefix}cert_check_refresh_cert_script"
  description      = "Refreshes the cert."
  input_file       = "${path.module}/test-container/refresh-cert.sh"
  destination_path = "/refresh-cert.sh"
  resource_query   = "pods | app='certs-test'"

  enabled = true
}