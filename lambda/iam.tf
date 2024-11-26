locals {
  role_name   = var.create_role ? coalesce(var.role_name, var.function_name, "*") : null
  policy_name = coalesce(var.policy_name, local.role_name, "*")

  log_group_arn  = aws_cloudwatch_log_group.lambda.arn
  log_group_name = aws_cloudwatch_log_group.lambda.name
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "lambda" {
  count = var.create_role ? 1 : 0

  name               = local.role_name
  description        = var.role_description
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "additional_policies" {
  count = var.create_role ? length(var.policies) : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = var.policies[count.index]
}

##################
# Cloudwatch Logs
##################

data "aws_iam_policy_document" "logs" {
  count = var.create_role ? 1 : 0

  statement {
    effect = "Allow"

    actions = compact([
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ])

    resources = flatten([for _, v in ["%v:*", "%v:*:*"] : format(v, local.log_group_arn)])
  }
}

resource "aws_iam_policy" "logs" {
  count = var.create_role ? 1 : 0

  name   = "${local.policy_name}-logs"
  path   = coalesce(var.policy_path, var.role_path, "*")
  policy = data.aws_iam_policy_document.logs[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "logs" {
  count = var.create_role ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.logs[0].arn
}

######
# VPC
######
data "aws_iam_policy" "vpc" {
  count = var.create_role && var.attach_network_policy ? 1 : 0

  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}

resource "aws_iam_policy" "vpc" {
  count = var.create_role && var.attach_network_policy ? 1 : 0

  name   = "${local.policy_name}-vpc"
  path   = var.policy_path
  policy = data.aws_iam_policy.vpc[0].policy
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "vpc" {
  count = var.create_role && var.attach_network_policy ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.vpc[0].arn
}


data "aws_iam_policy_document" "sqs_trigger_permission" {
  count = var.create_role && length(var.sqs_queue_trigger_arns) > 0 ? 1 : 0
  statement {
    sid       = "AllowSQSPermissions"
    effect    = "Allow"
    resources = var.sqs_queue_trigger_arns

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
  }
}

resource "aws_iam_policy" "sqs_trigger_permission" {
  count = var.create_role && length(var.sqs_queue_trigger_arns) > 0 ? 1 : 0

  name   = "${local.policy_name}-sqs-trigger-access"
  path   = coalesce(var.policy_path, var.role_path, "*")
  policy = data.aws_iam_policy_document.sqs_trigger_permission[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "sqs_trigger_permission" {
  count      = var.create_role && length(var.sqs_queue_trigger_arns) > 0 ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.sqs_trigger_permission[0].arn
}

resource "aws_iam_role_policy_attachment" "insights_policy" {
  count      = var.enable_lambda_insights ? 1 : 0
  role       = aws_iam_role.lambda[0].id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "lambda_allow_write_xray" {
  count      =  var.enable_lambda_insights ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}