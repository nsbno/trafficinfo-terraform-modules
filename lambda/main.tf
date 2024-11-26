data "aws_partition" "current" {}

resource "aws_lambda_function" "this" {
  function_name                  = "${var.name_prefix}-${var.function_name}"
  description                    = var.description
  role                           = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  timeout                        = var.timeout
  kms_key_arn                    = var.kms_key_arn
  architectures                  = var.architecture
  tags                           = var.tags
  source_code_hash               = var.source_code_hash
  publish                        = var.publish

  s3_bucket         = var.s3_existing_package.bucket
  s3_key            = var.s3_existing_package.key
  s3_object_version = var.s3_existing_package.version_id

  layers = var.enable_lambda_insights ? [
    "arn:aws:lambda:eu-west-1:580247275435:layer:LambdaInsightsExtension:33"
  ] : []

  dynamic "snap_start" {
    for_each = var.enable_snap_start ? [true] : []
    content {
      apply_on = "PublishedVersions"
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]

  dynamic "tracing_config" {
    for_each = var.enable_tracing ? [true] : []
    content {
      mode = "Active"
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name_prefix}-${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id
  tags              = var.tags
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  count = length(var.sqs_queue_trigger_arns)
  event_source_arn                   = var.sqs_queue_trigger_arns[count.index]
  enabled                            = true
  function_name                      = aws_lambda_function.this.qualified_arn
  batch_size = 100 // The largest number of records that Lambda will retrieve
  maximum_batching_window_in_seconds = 30  // The maximum amount of time to gather records before invoking the function
}

resource "aws_lambda_alias" "alias" {
  count            = var.create_alias ? 1 : 0
  name             = "${aws_lambda_function.this.function_name}-alias"
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
}