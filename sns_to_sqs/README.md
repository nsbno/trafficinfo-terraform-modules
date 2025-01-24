# Module for subscribing a SQS queue to a SNS topic

This Terraform module creates and manages the subscription of an SNS topic to an SQS queue, including the necessary SQS queue policy.

## Usage example

```hcl
module "sns_to_sqs" {
  source = "github.com/nsbno/trafficinfo-terraform-modules/sns_to_sqs?ref=db20724"

  enable                = true
  topic_arn             = "arn:aws:sns:us-east-1:123456789012:my-topic"
  queue_arn             = "arn:aws:sqs:us-east-1:123456789012:my-queue"
  queue_url             = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
  raw_message_delivery  = true
  filter_policy         = {
    countryCode = ["NO"]
  }
}