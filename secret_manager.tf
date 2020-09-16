/*
* Copyright (c) 2020 Risk Focus Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

resource "aws_secretsmanager_secret" "rhodium" {
  name = "rhodium_secret"
}

variable "rhodium_secrets" {
  default = {
    "api.slack_signing_secret" = "none"
    "slackbot.slack_bot_token" = "none"
    "slackbot.slack_channel" = "none"
  }

  type = map
}

resource "aws_secretsmanager_secret_version" "rhodium" {
  secret_id     = aws_secretsmanager_secret.rhodium.id
  secret_string = jsonencode(var.rhodium_secrets)
}
