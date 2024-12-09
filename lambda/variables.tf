variable "current_account" {
  description = "Account id of the current account"
  type        = string
}

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}


variable "tags" {
  description = "A map of tags to assign to resources."
  type = map(string)
  default = {}
}

variable "cloudwatch_logs_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = 14
}

variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 1024
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  type        = number
  default     = -1
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = "java21"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "kms_key_arn" {
  description = "The ARN of KMS key to use by your Lambda Function. Encrypt env vars"
  type        = string
  default     = null
}

variable "architecture" {
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type = list(string)
  default     = null
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type = list(string)
  default     = null
}

variable "attach_network_policy" {
  description = "Controls whether VPC/network policy should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "s3_existing_package" {
  description = "The S3 bucket object with keys bucket, key, version pointing to an existing zip-file to use"
  type = object({
    bucket     = string
    key        = string
    version_id = string
  })
}
variable "source_code_hash" {
  description = " (Optional) Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file"
  type        = string
  default     = null
}

variable "publish" {
  description = "(Optional) Whether to publish creation/change as new Lambda Function Version. Defaults to false. Must be enabled to use snapstart"
  type        = bool
  default     = true
}

variable "enable_snap_start" {
  description = "Enable Lambda snapstart"
  type        = bool
  default     = true
}

variable "schedule" {
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule_expression or event_pattern is required. Can only be used on the default event bus."
  type        = string
  default     = null
}


######
# IAM
######

variable "lambda_role" {
  description = " IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details."
  type        = string
  default     = ""
}


variable "create_role" {
  description = "Controls whether IAM role for Lambda Function should be created"
  type        = bool
  default     = true
}


variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
  type        = string
  default     = "/"
}

variable "policies" {
  description = "List of policy statements ARN to attach to Lambda Function role"
  type = list(string)
  default = []
}

variable "policy_name" {
  description = "IAM policy name. It override the default value, which is the same as role_name"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path of policies to that should be added to IAM role for Lambda Function"
  type        = string
  default     = null
}

variable "sqs_queue_trigger_arns" {
  description = "ARNs of SQS queues that can trigger this Lambda function"
  type = list(string)
  default = []
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type = map(string)
  default = {}
}

variable "alarm_actions" {
  description = "The ARNs of the SNS topics to send alarm statuses to"
  type = list(string)
  default = []
}

variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = true
}

variable "enable_lambda_insights" {
  description = "Enable Lambda Insights"
  type        = bool
  default     = false
}

variable "provisioned_concurrency_config" {
  description = "Lambda Provisioned Concurrency Configuration. If alias name is not given, the provisioned concurrency will apply to the latest version. Cannot be enabled at the same time as snapstart"
  type = object({
    provisioned_concurrent_executions = number
    alias_name = optional(string)
  })
  default = null
}

variable "enable_tracing" {
  default     = true
  description = "Enable X-Ray tracing for Lambda Function"
  type        = bool
}

variable "create_alias" {
  default     = false
  description = "Should a lambda function alias be created?"
  type        = bool
}

variable "sqs_lambda_event_source_mapping_maximum_concurrency" {
  description = "Limits the number of concurrent Lambda instances that the Amazon SQS event source can invoke. Must be greater than or equal to 2"
  type        = number
  default     = null
  validation {
    condition     = var.sqs_lambda_event_source_mapping_maximum_concurrency == null ? true : var.sqs_lambda_event_source_mapping_maximum_concurrency >= 2
    error_message = "sqs_lambda_event_source_mapping_maximum_concurrency must be greater than or equal to 2"
  }
}