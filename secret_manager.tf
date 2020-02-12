resource "aws_secretsmanager_secret" "rhodium" {
  name = "rhodium_secret"
}

variable "rhodium_secrets" {
  default = {
    "api.slack_signing_secret" = "none"
    "notificator.slack_bot_token" = "none"
    "notificator.slack_channel" = "none"
  }

  type = map
}

resource "aws_secretsmanager_secret_version" "rhodium" {
  secret_id     = aws_secretsmanager_secret.rhodium.id
  secret_string = jsonencode(var.rhodium_secrets)
}
