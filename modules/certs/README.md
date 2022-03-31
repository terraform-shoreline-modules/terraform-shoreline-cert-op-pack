# Shoreline Cert Op Pack

<table role="table" style="vertical-align: middle;">
  <thead>
    <tr style="background-color: #fff">
      <th style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;" colspan="3">Provider Support</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #E2E2E2">
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">AWS</td>
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">Azure</td>
      <td style="padding: 6px 13px; border: 1px solid #B1B1B1; text-align: center;">GCP</td>
    </tr>
    <tr>
      <td style="padding-top: 6px; vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="padding-top: 6px; vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
      <td style="padding-top: 6px; vertical-align: bottom; border: 1px solid #B1B1B1; text-align: center;"><svg xmlns="http://www.w3.org/2000/svg" style="width: 1.5rem; height: 1.5rem;" fill="none" viewBox="0 0 24 24" stroke="#6CB169"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg></td>
    </tr>
  </tbody>
</table>

The Cert Op Pack monitors SSL/TLS certificates. If the URL has a certificate expiring within the defined limit it triggers a Shoreline Alarm. Additionally, if you enabled and configured the remediation Action, then it renews the certificate using the `certbot` CLI tool.

## Requirements

The following tools are required on the monitored resources, with appropriate permissions:

1. OpenSSL.
1. If you want to enable the remediation: The [certbot CLI](https://certbot.eff.org/). This certbot has to be configured already so `certbot renew` command can run.

## Example

The following example monitors certificates on target resources. When a cert's expiration date falls within `max_days` it fires an Alarm. With `auto_remediate` enabled, the `certbot` command executes and renews the certificate.
```hcl
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
  url     = "<SHORELINE_CLUSTER_API_ENDPOINT>"
}

module "cert_expire" {
  # Location of the module:
  source = "shorelinesoftware/modules/shoreline//modules/certs"

  # Prefix to allow multiple instances of the module, with different params:
  prefix = "example_"

  # The URL of the target web server that we need to check the SSL/TLS certs for:
  cert_test_url = "shoreline.io"

  # Port of the web server that we need to check the SSL/TLS certs for(Optional: default value is 443):
  port          = 443
  # This is the minimum number of days remaining until the SSL/TLS cert expires(Optional: default value is 30):
  min_cert_days = 30

  # Resource query to select the resource that runs the alarm. If auto_remediate is set this is also the resource that has the certbot config:
  resource_query          = "hosts | limit = 1"
  # Openssl binary location in the resource which specified with resource_query(Optional: default value is "openssl"):
  openssl_binary_location = "/usr/local/bin/openssl"
  # Destination (on selected resources) for the cert script(Optional: default value is /home):
  cert_script_path        = "/home"
  # Creates certbot renewal bot. If set to true details can be set by vars starting with 'certbot_'.
  auto_remediate          = true
  # Adds sudo to certbot renew command
  certbot_use_sudo        = false
  # Certbot binary location.
  certbot_executable      = "./certbot"
  # Certbot renew pre hook command. It happens before certbot renew command happens.
  certbot_pre_hook        = "nginx stop"
  # Certbot renew post hook command. It happens after certbot renew command happens.
  certbot_post_hook       = "nginx start"
  # Forces renewal of the given certificates. It only needs forcing if the renewal time hasn't come yet.
  certbot_force_renew     = true
  # Additional flags that can be used in certbot renew command that separated by spaces(for example: --no-autorenew -q --deploy-hook \"sudo systemctl stop nginx\".
  certbot_flags           = "--additional-flag"
}
```

## Manual command examples

These commands use Shoreline's expressive [Op language](https://docs.shoreline.io/op) to retrieve fleet-wide data using the generated Actions from the certs module.

-> These commands can be executed within the [Shoreline CLI](https://docs.shoreline.io/cli) or [Shoreline Notebooks](https://docs.shoreline.io/ui/notebooks).
### Manually check expiry of the given cert

```
op> pods | name =~ 'shoreline' | `echo | openssl s_client -servername shoreline.io -connect shoreline.io:443 | openssl x509 -noout -enddate`

 ID | TYPE      | NAME                                        | REGION    | AZ         | STATUS | STDOUT
 70 | CONTAINER | shoreline.shoreline-ltgdm.shoreline         | us-west-2 | us-west-2b |   0    |  notAfter=Apr  8 22:12:53 2022 GMT
    |           |                                             |           |            |        |
```

### List triggered cert Alarms

```
op> events | alarm_name =~ 'cert'

 RESOURCE_NAME      | RESOURCE_TYPE | ALARM_NAME               | STATUS   | STEP_TYPE   | TIMESTAMP                 | DESCRIPTION
 default.certs-test | POD           | example_cert_expire      | resolved |             |                           | Alarm for SSL or TLS cert expiration.
                    |               |                          |          | ALARM_FIRE  | 2022-03-22T16:41:42+03:00 | cert will expire soon.
                    |               |                          |          | ALARM_CLEAR | 2022-03-22T16:41:52+03:00 | cert no longer will expire soon.
```

-> See the [Shoreline Events documentation](https://docs.shoreline.io/op/events) for details.
