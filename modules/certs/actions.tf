# Create the certbot renew command.
locals {
  certbot_sudo             = var.certbot_use_sudo ? "sudo " : ""
  certbot_force_renew      = var.certbot_force_renew ? "--force-renewal" : ""
  certbot_pre_hook         = var.certbot_pre_hook != "" ? "--pre-hook '${var.certbot_pre_hook}'" : ""
  certbot_post_hook        = var.certbot_pre_hook != "" ? "--post-hook '${var.certbot_post_hook}'" : ""
  certbot_additional_flags = var.certbot_flags != "" ? "${var.certbot_flags}" : ""
  certbot_command          = "${local.certbot_sudo}${var.certbot_executable} renew ${local.certbot_pre_hook} ${local.certbot_post_hook} ${local.certbot_force_renew} ${local.certbot_additional_flags}"
}

# Action to renew certificate on the chosen resource.
resource "shoreline_action" "cert_expire_renew" {
  count       = var.auto_remediate ? 1 : 0
  name        = "${var.prefix}cert_expire_renew"
  description = "Renews the certificate on the given resource using the 'certbot renew' command."
  command     = "`${local.certbot_command}`"
  shell       = "/bin/bash"
  timeout     = 60000 # milliseconds

  # UI / CLI annotation informational messages:
  start_short_template    = "Renewing the given cert."
  error_short_template    = "Error renewing the given cert."
  complete_short_template = "Finished renewing the given cert."
  start_long_template     = "Renewing the '${var.cert_test_url}' cert."
  error_long_template     = "Error renewing the '${var.cert_test_url}' cert."
  complete_long_template  = "Finished renewing the '${var.cert_test_url}' cert."

  enabled = true
}

# Action to check the cert expiry
resource "shoreline_action" "cert_expire_check_action" {
  name           = "${var.prefix}cert_expire_check_action"
  description    = "Check the cert of the given URL and report back if it's expiring."
  # Run the cert script (which was copied by the cert_expire_check_script file object).
  command        = "`cd ${var.cert_script_path} && chmod +x ./check_cert.sh && ./check_cert.sh`"
  # Parameters passed in:
  #    URL of the certificate
  #    PORT of the URL
  #    EXPIRE_SECONDS is the max seconds until the certificate expires
  #    OPENSSL_BINARY_LOCATION is full path of the openssl binary(if in PATH "openssl" also works)
  params         = [ "URL", "PORT", "EXPIRE_SECONDS", "OPENSSL_BINARY_LOCATION" ]
  resource_query = var.resource_query

  # UI / CLI annotation informational messages:
  start_short_template    = "Checking the cert for ${var.cert_test_url}."
  error_short_template    = "Error checking the cert for ${var.cert_test_url}."
  complete_short_template = "Finished checking the cert for ${var.cert_test_url}."

  enabled = true
}