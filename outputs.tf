output "worker_role_arn" {
  value = module.lambda_worker.role_arn
}

output "slack_events_endpoint" {
  value = var.enable_apigw_domain ? "https://${aws_api_gateway_domain_name.rhodium[0].domain_name}/slack/events" : "${aws_api_gateway_deployment.current.invoke_url}current/slack/events"
}


output "slack_interactive_components_endpoint" {
  value = var.enable_apigw_domain ? "https://${aws_api_gateway_domain_name.rhodium[0].domain_name}/slack/interactive-endpoint" : "${aws_api_gateway_deployment.current.invoke_url}current/slack/interactive-endpoint"
}
