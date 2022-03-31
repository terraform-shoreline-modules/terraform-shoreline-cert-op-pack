################################################################################
# Module: cert_expire
# 
# Automatically detect SSL/TLS certificates of the web server on target URL.
# Then calculate the remaining days and compare it with the given expiration days.
# Raise an alarm if SSL/TLS cert of the target will expire sooner than given expiration days.
#
# Example usage:
#
#   module "cert_expire" {
#     # Location of the module:
#     source        = "../"
#   
#     # Prefix to allow multiple instances of the module, with different params:
#     prefix        = "example_"
#   
#     # The URL of the target web server that we need to check the SSL/TLS certs for:
#     cert_test_url = "shoreline.io"
#   
#     # Port of the web server that we need to check the SSL/TLS certs for(Optional: default value is 443):
#     port          = 443
#
#     # This is the minimum number of days remaining until the SSL/TLS cert expires(Optional: default value is 30):
#     min_cert_days = 30
#
#
#     # Resource query to select the resource that runs the alarm. If auto_remediate is set this is also the resource that has the certbot config:
#     resource_query          = "hosts | limit = 1"
#
#     # Openssl binary location in the resource which specified with resource_query(Optional: default value is "openssl"):
#     openssl_binary_location = "/usr/local/bin/openssl"
#
#     # Destination (on selected resources) for the cert script(Optional: default value is /home):
#     cert_script_path        = "/home"
#
#     # Creates certbot renewal bot. If set to true details can be set by vars starting with 'certbot_'.
#     auto_remediate          = true
#
#     # Adds sudo to certbot renew command
#     certbot_use_sudo        = false
#
#     # Certbot binary location.
#     certbot_executable      = "./certbot"
#
#     # Certbot renew pre hook command. It happens before certbot renew command happens.
#     certbot_pre_hook        = "nginx stop"
#
#     # Certbot renew post hook command. It happens after certbot renew command happens.
#     certbot_post_hook       = "nginx start"
#
#     # Forces renewal of the given certificates. It only needs forcing if the renewal time hasn't come yet.
#     certbot_force_renew     = true
#
#     # Additional flags that can be used in certbot renew command that separated by spaces(for example: --no-autorenew -q --deploy-hook \"sudo systemctl stop nginx\".
#     certbot_flags           = "--additional-flag"
#
#   }

################################################################################

