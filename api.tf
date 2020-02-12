module "lambda_api" {
  #source = "github.com/claranet/terraform-aws-lambda"
  source = "./modules/terraform-aws-lambda"

  function_name                  = "cadmium3-rhodium-api"
  description                    = "Rhodium Infrastructure API"
  handler                        = "rhodium.api.handle_request"
  runtime                        = "python3.8"
  timeout                        = 30
  memory_size                    = 512
  reserved_concurrent_executions = 1

  // Attach a policy.
  policy = {
    json = data.aws_iam_policy_document.lambda_api.json
  }

  // Specify a file or directory for the source code.
  #source_path = "${path.root}/../../cloud-scheduler/src"
  s3_bucket_name = var.s3_bucket_name
  s3_bucket_key  = var.s3_bucket_path
}

data aws_iam_policy_document lambda_api {
  statement {
    effect    = "Allow"
    actions   = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.rhodium_environments.arn,
      aws_dynamodb_table.rhodium_actions.arn
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [
      aws_secretsmanager_secret.rhodium.arn
    ]
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "rhodium" {
  name = "rhodium"
}

resource "aws_api_gateway_stage" "current" {
  deployment_id = aws_api_gateway_deployment.current.id
  rest_api_id   = aws_api_gateway_rest_api.rhodium.id
  stage_name    = "current"
  description   = "Deployed at ${timestamp()}"
}

resource "aws_api_gateway_deployment" "current" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id       = aws_api_gateway_rest_api.rhodium.id
  stage_description = "Deployed at ${timestamp()}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "{proxy+}"
  parent_id   = aws_api_gateway_rest_api.rhodium.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.rhodium.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.rhodium.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.rhodium.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_api.function_invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_api.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rhodium.execution_arn}/*/*/*"
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda_api" {
  name              = "/aws/lambda/${module.lambda_api.function_name}"
  retention_in_days = 3
}