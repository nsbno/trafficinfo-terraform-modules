output "sqs_queue_id" {
  description = "The ID of the SQS queue"
  value       = aws_sqs_queue.this.id
}

output "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "sqs_queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.this.url
}

output "sqs_dead_letter_queue_id" {
  description = "The ID of the dead letter SQS queue"
  value       = aws_sqs_queue.this_dead_letter[0].id
}

output "sqs_dead_letter_queue_arn" {
  description = "The ARN of the dead letter SQS queue"
  value       = aws_sqs_queue.this_dead_letter[0].arn
}

output "sqs_dead_letter_queue_url" {
  description = "The URL of the dead letter SQS queue"
  value       = aws_sqs_queue.this_dead_letter[0].url
}
