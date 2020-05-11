variable "s3_bucket_name" {
  description = "Rhodiume package - name of s3 bucket"
  type        = string
  default     = "cadmium3-rhodium-distribution"
}

variable "s3_bucket_path" {
  description = "Rhodiume package - path of s3 bucket"
  type        = string
  default     = "rhodium-latest.zip"
}

variable "domain" {
  type    = string
  default = ""
}

variable "enable_apigw_domain" {
  default = true
}

variable "environment" {
  default = {
    "RHODIUM_CONFIG_CORE__SSM_SECRET_NAME": "rhodium_secret",
    "RHODIUM_CONFIG_CORE__PROCESSED_ACTIONS_LIMIT": "100",
    "RHODIUM_CONFIG_API__EXTERNAL_PARAMS": "aws_ssm",
    "RHODIUM_CONFIG_NOTIFICATOR__SLACKBOT__PARAMS__SLACK_BOT_TOKEN": "",
    "RHODIUM_CONFIG_NOTIFICATOR__SLACKBOT__PARAMS__SLACK_CHANNEL": "",
    "RHODIUM_CONFIG_NOTIFICATOR__SLACKBOT__PARAMS__STORAGE": "",
    "RHODIUM_CONFIG_NOTIFICATOR__SLACKBOT__EXTERNAL_PARAMS": "aws_ssm",
    "RHODIUM_CONFIG_CLOUDS_PLUGINS__AWS__PARAMS__ENVIRONMENT_TAG": "Namespace",
    "RHODIUM_CONFIG_CLOUDS_PLUGINS__AWS__PARAMS__SCHEDULE_TAG": "Schedule",
    "RHODIUM_CONFIG_CLOUDS_PLUGINS__AWS__PARAMS__TIER_TAG": "Tier",
    "RHODIUM_CONFIG_STORAGE": "dynamodb"
  }
}

variable "environment_extra" {
  default = {}
}
