variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
  default     = 345600 # 4 days
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call waits for a message to arrive"
  type        = number
  default     = 20
}

variable "enable_dead_letter_queue" {
  description = "Enable the dead letter queue"
  type        = bool
  default     = false
}

variable "message_retention_seconds_dlq" {
  description = "The number of seconds Amazon SQS retains a message in the dead letter queue"
  type        = number
  default     = 1209600 # 14 days
}

variable "max_receive_count_dlq" {
  description = "The number of times a message is delivered to the source queue before being moved to the dead letter queue"
  type        = number
  default     = 5
}

variable "enable_alarms" {
  description = "Enable the CloudWatch alarms"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "The actions to take when the alarm state is triggered. E.g an SNS topic ARN"
  type        = list(string)
  default     = null
}
