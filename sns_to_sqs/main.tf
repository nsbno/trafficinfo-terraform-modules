resource "aws_sns_topic_subscription" "this" {
  count                = var.enable ? 1 : 0
  topic_arn            = var.topic_arn
  protocol             = "sqs"
  endpoint             = var.queue_arn
  raw_message_delivery = var.raw_message_delivery
  filter_policy        = var.filter_policy != null ? jsonencode(var.filter_policy) : null
}


resource "aws_sqs_queue_policy" "this" {
  count     = var.enable ? 1 : 0
  queue_url = var.queue_url
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    actions   = ["sqs:SendMessage"]
    resources = [var.queue_arn]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.topic_arn]
    }
  }
}
