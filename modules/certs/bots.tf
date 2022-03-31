# Bot that fires the cert renewal action when cert of the given url expires expires in the chosen days.
resource "shoreline_bot" "cert_expire_renew_bot" {
  count       = var.auto_remediate ? 1 : 0
  name        = "${var.prefix}cert_renew_bot"
  description = "Certificate renewal handler bot"
  # If cert of the given url expires expires in the chosen days then renew it.
  command     = "if ${shoreline_alarm.cert_expire_alarm.name} then ${shoreline_action.cert_expire_renew[0].name} fi"

  # general type of bot this can be "standard" or "custom"
  family = "custom"

  enabled = true
}