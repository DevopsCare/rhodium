module "lambda_worker" {
  #source = "github.com/claranet/terraform-aws-lambda"
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

  // Specify a file or directory for the source code.
  #source_path = "${path.root}/../../cloud-scheduler/src"
  s3_bucket_name = var.s3_bucket_name
  s3_bucket_key  = var.s3_bucket_path
}

data aws_iam_policy_document lambda_worker_extra {
  statement {
    effect    = "Allow"
    actions   = [
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:PutItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:Scan"
    ]
    resources = [aws_dynamodb_table.rhodium_environments.arn]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "rds:StopDBInstance",
      "rds:StartDBInstance",
    ]
    resources = ["*"]
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
  statement {
    effect    = "Allow"
    actions   = [
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