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

output "worker_role_arn" {
  value = module.lambda_worker.role_arn
}

output "slack_events_endpoint" {
  value = var.enable_apigw_domain ? "https://${aws_api_gateway_domain_name.rhodium[0].domain_name}/slack/events" : "${aws_api_gateway_deployment.current.invoke_url}current/slack/events"
}


output "slack_interactive_components_endpoint" {
  value = var.enable_apigw_domain ? "https://${aws_api_gateway_domain_name.rhodium[0].domain_name}/slack/interactive-endpoint" : "${aws_api_gateway_deployment.current.invoke_url}current/slack/interactive-endpoint"
}
