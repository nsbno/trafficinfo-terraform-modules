# SQS Queue Terraform Module

This Terraform module creates and manages AWS SQS queues, 
including optional dead-letter queues (DLQ) and redrive policies.

## Usage example

```hcl
module "sqs_queue" {
  source = "github.com/nsbno/trafficinfo-terraform-modules/sqs_queue?ref=db20724"

  queue_name                   = "my-queue"
  message_retention_seconds    = 86400
  receive_wait_time_seconds    = 20
  enable_dead_letter_queue     = true
  message_retention_seconds_dlq = 1209600
  max_receive_count_dlq        = 5
}