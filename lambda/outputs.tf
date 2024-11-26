# Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.this.arn
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_qualified_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = aws_lambda_function.this.qualified_arn
}

output "lambda_function_version" {
  description = "Latest published version of Lambda Function"
  value       = aws_lambda_function.this.version
}

output "lambda_function_last_modified" {
  description = "The date Lambda Function resource was last modified"
  value       = aws_lambda_function.this.last_modified
}

output "lambda_function_kms_key_arn" {
  description = "The ARN for the KMS encryption key of Lambda Function"
  value       = aws_lambda_function.this.kms_key_arn
}

output "lambda_function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = aws_lambda_function.this.source_code_hash
}

output "lambda_function_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = aws_lambda_function.this.source_code_size
}

output "lambda_function_signing_job_arn" {
  description = "ARN of the signing job"
  value       = aws_lambda_function.this.signing_job_arn
}

output "lambda_function_signing_profile_version_arn" {
  description = "ARN of the signing profile version"
  value       = aws_lambda_function.this.signing_profile_version_arn
}

# IAM Role
output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda Function"
  value       = try(aws_iam_role.lambda[0].arn, "")
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda Function"
  value       = try(aws_iam_role.lambda[0].name, "")
}

output "lambda_role_unique_id" {
  description = "The unique id of the IAM role created for the Lambda Function"
  value       = try(aws_iam_role.lambda[0].unique_id, "")
}

# CloudWatch Log Group
output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = local.log_group_arn
}

output "lambda_cloudwatch_log_group_name" {
  description = "The name of the Cloudwatch Log Group"
  value       = local.log_group_name
}

output "cloudwatch_lambda_error_metric_alarm_name" {
  description = "The name of the Cloudwatch alarm for Lambda errors"
  value       = aws_cloudwatch_metric_alarm.lambda_error_alarm[0].alarm_name
}

output "cloudwatch_lambda_timeout_metric_alarm_name" {
  description = "The name of the Cloudwatch alarm for Lambda timeouts"
  value       = aws_cloudwatch_metric_alarm.lambda_timeout_alarm[0].alarm_name
}

output "alias_name" {
  description = "Name of the alias. Null if alias was not created"
  value       = var.create_alias ? aws_lambda_alias.alias[0].name : null
}

output "alias_invoke_arn" {
  description = "Invoke ARN of the alias. Null if alias was not created"
  value       = var.create_alias ? aws_lambda_alias.alias[0].invoke_arn : null
}