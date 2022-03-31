locals {
  # convert days to seconds that openssl want as
  expire_seconds = var.min_cert_days * 86400
  resource_query = var.resource_query != "" ? var.resource_query : "pods | app='shoreline' | namespace='shoreline1' | limit=1"
}

# Alarm that triggers when the given cert expires soon.
resource "shoreline_alarm" "cert_expire_alarm" {
  name               = "${var.prefix}cert_expire"
  description        = "Alarm for SSL or TLS cert expiration."
  # The query that starts the alarm: cert of the target will expire in given duration.
  fire_query         = "${shoreline_action.cert_expire_check_action.name}(URL='${var.cert_test_url}', PORT='${var.port}', EXPIRE_SECONDS='${local.expire_seconds}', OPENSSL_BINARY_LOCATION='${var.openssl_binary_location}') == 10"
  # The query that ends the alarm: cert of the target won't expire in given duration.
  clear_query        = "${shoreline_action.cert_expire_check_action.name}(URL='${var.cert_test_url}', PORT='${var.port}', EXPIRE_SECONDS='${local.expire_seconds}', OPENSSL_BINARY_LOCATION='${var.openssl_binary_location}') == 0"
  # How often is the alarm evaluated. This is a more slowly changing metric, so every checking everyday is fine(default value equals to day in seconds which is 86400).
  check_interval_sec = var.check_interval

  # UI / CLI annotation informational messages:
  fire_short_template    = "cert will expire soon."
  resolve_short_template = "cert no longer will expire soon."
  # include relevant parameters, in case the user has multiple instances of the alarm
  fire_long_template     = "Cert of '${var.cert_test_url}' will expire before ${var.min_cert_days} days!"
  resolve_long_template  = "Cert of '${var.cert_test_url}' won't expire before ${var.min_cert_days} days."

  # alarm is raised local to a resource (vs global)
  raise_for      = "local"
  # raised on a linux command (not a standard metric)
  metric_name    = "check_cert"
  # general type of alarm ("metric", "custom", or "system check")
  family         = "custom"
  resource_query = local.resource_query

  # low-frequency, and a linux command, so compiling won't help
  compile_eligible = false

  enabled = true
}