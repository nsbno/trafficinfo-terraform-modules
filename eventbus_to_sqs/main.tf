############################################
# EventBridge SQS configuration
############################################

// Policy for letting the EventBridge rule push updates to the SQS queue
data "aws_iam_policy_document" "this" {
  statement {
    sid    = "1"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]
    resources = [var.sqs_queue_config.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [aws_cloudwatch_event_rule.this.arn]
    }
  }
}

// Add the policy to the queue
resource "aws_sqs_queue_policy" "this" {
  queue_url = var.sqs_queue_config.url
  policy    = data.aws_iam_policy_document.this.json
}

resource "aws_cloudwatch_event_rule" "this" {
  name           = var.event_rule_name
  event_bus_name = var.event_bus_name
  description    = var.description
  event_pattern = jsonencode({
    source      = var.event_pattern.source,
    detail-type = var.event_pattern.detail_type
  })
  state = var.enable_rule ? "ENABLED" : "DISABLED"
}

resource "aws_cloudwatch_event_target" "this" {
  rule           = aws_cloudwatch_event_rule.this.name
  event_bus_name = var.event_bus_name
  target_id      = var.event_target_id
  arn            = var.sqs_queue_config.arn
  input_path     = var.event_target_input_path

  dynamic "dead_letter_config" {
    for_each = var.dlq_queue_config!=null ? [true] : []
    content {
      arn = var.dlq_queue_config.arn
    }
  }
}