module "lambda_worker" {
  source = "./modules/terraform-aws-lambda"

  function_name                  = "cadmium3-rhodium-worker"
  description                    = "Rhodium Infrastructure Worker"
  handler                        = "rhodium.main.main_cycle"
  runtime                        = "python3.8"
  timeout                        = 300
  memory_size                    = 512
  reserved_concurrent_executions = 1

  lambda_at_edge = false

  // Attach a policy.
  policy = {
    json = data.aws_iam_policy_document.lambda_worker_extra.json
  }

  s3_bucket_name = var.s3_bucket_name
  s3_bucket_key  = var.s3_bucket_path

  environment = {
    variables = merge(var.environment, var.environment_extra)
  }
}

data "aws_iam_policy_document" "lambda_worker_extra" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:PutItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:Scan"
    ]
    resources = [
      aws_dynamodb_table.rhodium_environments.arn,
      aws_dynamodb_table.rhodium_actions.arn,
      aws_dynamodb_table.rhodium_schedules.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "rds:StopDBInstance",
      "rds:StartDBInstance",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "rds:ListTagsForResource",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [
      aws_secretsmanager_secret.rhodium.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:SetDesiredCapacity",
    ]
    resources = [
      "*"
    ]
  }
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda_worker" {
  name              = "/aws/lambda/${module.lambda_worker.function_name}"
  retention_in_days = 3
}

resource "aws_cloudwatch_event_rule" "lambda_worker" {
  name        = "lambda-rhodium-worker"
  description = "Trigger Rhodium Worker"

  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_worker" {
  rule      = aws_cloudwatch_event_rule.lambda_worker.name
  target_id = "cadmium3-rhodium-worker"
  arn       = module.lambda_worker.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rhodium_worker" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_worker.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_worker.arn
}

