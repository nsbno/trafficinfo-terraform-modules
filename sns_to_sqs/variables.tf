variable "enable" {
  description = "Enable the SNS topic subscription and SQS queue policy"
  type        = bool
  default     = true
}

variable "topic_arn" {
  description = "The ARN of the SNS topic"
  type        = string
}

variable "queue_arn" {
  description = "The ARN of the SQS queue"
  type        = string
}

variable "queue_url" {
  description = "The URL of the SQS queue"
  type        = string
}

variable "raw_message_delivery" {
  description = "Whether to enable raw message delivery"
  type        = bool
  default     = true
}

variable "filter_policy" {
  description = "The filter policy for the SNS subscription"
  type        = map(any)
  default     = null
}
