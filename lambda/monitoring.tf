resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  count               = var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.function_name}-error-alarm"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Maximum"
  alarm_description   = "This metric monitors errors from the Lambda function: ${var.function_name}"
  treat_missing_data  = "ignore" # Ignore=maintain alarm state when data is missing
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  dimensions          = {
    FunctionName = aws_lambda_function.this.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_timeout_alarm" {
  count               = var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.function_name}-timeout-alarm"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  evaluation_periods  = 1
  metric_name         = "Timeout"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Maximum"
  alarm_description   = "This metric monitors timeouts for the Lambda function: ${var.function_name}"
  treat_missing_data  = "ignore" # Ignore=maintain alarm state when data is missing
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  dimensions          = {
    FunctionName = aws_lambda_function.this.function_name
  }
}

// Metric filter on JSON log levels from the Lambda function
resource "aws_cloudwatch_log_metric_filter" "lambda_log_events" {
  name           = "${var.function_name}-log-events"
  pattern        = "{ $.level = * }"
  log_group_name = aws_cloudwatch_log_group.lambda.name

  metric_transformation {
    name       = "LambdaLogEvents"
    namespace  = "${var.name_prefix}-${var.function_name}/${aws_lambda_function.this.function_name}"
    value      = "1"
    unit       = "Count"
    dimensions = { level = "$.level" }
  }
}

// TODO: Create alarms on log errors and warnings (?)