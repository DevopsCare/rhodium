data "aws_s3_bucket_object" "rhodium_archive" {
  bucket = var.s3_bucket_name
  key    = var.s3_bucket_key
}

resource "aws_lambda_function" "lambda" {
  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  layers                         = var.layers
  timeout                        = local.timeout
  publish                        = local.publish
  tags                           = var.tags

  # Use a generated filename to determine when the source code has changed.
  s3_bucket = var.s3_bucket_name
  s3_key    = var.s3_bucket_key

  source_code_hash = data.aws_s3_bucket_object.rhodium_archive.etag

  # Add dynamic blocks based on variables.

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }
}
