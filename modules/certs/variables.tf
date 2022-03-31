#NOTE: The api URL is passed in via the SHORELINE_URL env var.
#        SHORELINE_TOKEN is also required.

variable "prefix" {
  type        = string
  description = "A prefix to isolate multiple instances of the module with different parameters."
  default     = ""
}

variable "cert_test_url" {
  type        = string
  description = "The URL of the target web server that we need to check the SSL/TLS certs for."
}

variable "port" {
  type        = number
  description = "Port of the web server that we need to check the SSL/TLS certs for."
  default     = 443
}

variable "min_cert_days" {
  type        = number
  description = "This is the minimum number of days remaining until the SSL/TLS cert expires."
  default     = 30
}

variable "check_interval" {
  type        = number
  description = "Frequency in seconds to check the alarm."
  default     = 86400
}

variable "openssl_binary_location" {
  type        = string
  description = "Openssl binary location."
  default     = "openssl"
}

variable "auto_remediate" {
  type        = bool
  description = "Creates certbot renewal bot. If set to true details can be set by vars starting with 'certbot_'."
  default     = false
}

variable "certbot_use_sudo" {
  type        = bool
  description = "Adds sudo to certbot renew command."
  default     = false
}

variable "certbot_executable" {
  type        = string
  description = "Certbot executable binary location."
  default     = "certbot"
}

variable "certbot_pre_hook" {
  type        = string
  description = "Certbot renew pre hook command. It happens before certbot renew command happens(for example nginx stop)."
  default     = ""
}

variable "certbot_post_hook" {
  type        = string
  description = "Certbot renew post hook command. It happens after certbot renew command happens(for example nginx start)."
  default     = ""
}

variable "certbot_force_renew" {
  type        = bool
  description = "Forces renewal of the given certificates. It only needs forcing if the renewal time hasn't come yet."
  default     = true
}

variable "certbot_flags" {
  type        = string
  description = "Additional flags that can be used in certbot renew command that separated by spaces(for example: --no-autorenew -q --deploy-hook \"sudo systemctl stop nginx\"."
  default     = ""
}

variable "resource_query" {
  type        = string
  description = "Resource query to select the resource that runs the alarm. If auto_remediate is set this is also the resource that has the certbot config."
}

variable "cert_script_path" {
  type        = string
  description = "Destination (on selected resources) for the cert script."
  default     = "/home"
}
