resource "aws_cloudwatch_event_api_destination" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)
  name                             = var.data_to_elastic_event_rules[count.index].api_destination_name
  description                      = "Sends ${var.data_to_elastic_event_rules[count.index].detail_type} data to elastic"
  invocation_endpoint              = "${var.elastic_hostname}/${var.data_to_elastic_event_rules[count.index].index_name}/_doc"
  http_method                      = "POST"
  invocation_rate_limit_per_second = 300
  connection_arn                   = var.cloudwatch_connection_arn
}

resource "aws_cloudwatch_event_rule" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)
  name           = var.data_to_elastic_event_rules[count.index].api_destination_name
  description    = "Sends ${var.data_to_elastic_event_rules[count.index].detail_type} data to elastic"
  event_bus_name = var.event_bus_name
  event_pattern  = <<EOF
{
  "detail-type": [
    "${var.data_to_elastic_event_rules[count.index].detail_type}"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)
  rule           = aws_cloudwatch_event_rule.data_to_elastic[count.index].name
  event_bus_name = var.event_bus_name
  arn            = aws_cloudwatch_event_api_destination.data_to_elastic[count.index].arn
  role_arn       = aws_iam_role.data_to_elastic[count.index].arn
  http_target {
    header_parameters = { "Content-Type" : "application/json" }
  }

  retry_policy {
    maximum_event_age_in_seconds = 3600
    maximum_retry_attempts       = 3
  }
}

############################################
# IAM
############################################
resource "aws_iam_role" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)

  name = var.data_to_elastic_event_rules[count.index].api_destination_name

  description = "Role for sending ${var.data_to_elastic_event_rules[count.index].detail_type} data to api destinations for Elastic"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)
  role       = aws_iam_role.data_to_elastic[count.index].name
  policy_arn = aws_iam_policy.data_to_elastic[count.index].arn
}

resource "aws_iam_policy" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)

  name        = var.data_to_elastic_event_rules[count.index].api_destination_name
  description = "${var.data_to_elastic_event_rules[count.index].detail_type} data to elastic policy"
  path        = "/${var.name_prefix}-${var.application_name}/eventbridge/elastic/"

  policy = data.aws_iam_policy_document.data_to_elastic[count.index].json
}

data "aws_iam_policy_document" "data_to_elastic" {
  count = length(var.data_to_elastic_event_rules)
  statement {
    effect = "Allow"
    actions = ["events:InvokeApiDestination"]
    resources = [aws_cloudwatch_event_api_destination.data_to_elastic[count.index].arn]
  }
}
