output "worker_role_arn" {
  value = module.lambda_worker.role_arn
}

output slack_events_api_callack {
  value = aws_api_gateway_deployment.current.invoke_url
}
