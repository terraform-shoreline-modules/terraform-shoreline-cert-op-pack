# Push the script that checks cert expiration date.
resource "shoreline_file" "cert_expire_cert_script" {
  name             = "${var.prefix}cert_script"
  description      = "Script to check cert expiration date."
  input_file       = "${path.module}/data/check_cert.sh"              # source file (relative to this module)
  destination_path = "${var.cert_script_path}/check_cert.sh"          # where it is copied to on the selected resources
  resource_query   = var.resource_query                               # which resources to copy to

  enabled = true
}
