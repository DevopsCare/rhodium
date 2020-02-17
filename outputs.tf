output "worker_role_arn" {
  value = module.lambda_worker.role_arn
}

output slack_events_api_callack {
  value = var.enable_apigw_domain ? "https://${aws_api_gateway_domain_name.rhodium[0].domain_name}/" : aws_api_gateway_deployment.current.invoke_url
}
