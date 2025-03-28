variable "description" {
  description = "Description of the EventBridge rule"
  type        = string
  default     = "Send data to SQS queue"
}

variable "sqs_queue_config" {
  description = "A map that defines the configuration for the target SQS queue"
  type = object({
    url = string
    arn = string
  })
}

variable "dlq_queue_config" {
  description = "A map that defines the DLQ configuration for the target DLQ SQS queue"
  type = object({
    arn = string
  })
  default = null
}

variable "event_bus_name" {
  description = "Name of the EventBridge event bus"
  type        = string
}

variable "event_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "enable_rule" {
  description = "Enable the EventBridge rule"
  type        = bool
  default     = true
}

variable "event_target_id" {
  description = "ID of the target to associate with the rule. Random if null"
  type        = string
  default     = null
}

variable "event_target_input_path" {
  description = "The value of the JSONPath that is used for extracting part of the matched event when passing it to the target"
  type        = string
  default     = "$.detail"
}

variable "event_pattern" {
  description = "The event pattern to match in the bus."
  type = object({
    source = optional(list(string), null)
    detail_type = optional(list(string), null)
  })
}

variable "is_fifo" {
  default     = false
  description = "Is the SQS queue to send mesaages to a FIFO queue."
  type        = bool
}

variable "messageGroupId" {
  description = "Used when the SQS queue is a FIFO queue."
  default     = null
  type        = string
}
