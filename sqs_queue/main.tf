
// The OTR topic where all OTR changes are published
data "aws_sns_topic" "otr_updates" {
  name = "trafficinfo-sns_otr-changed-operating-train"
}


resource "aws_sqs_queue" "this" {
  name                      = var.queue_name
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
}

resource "aws_sqs_queue" "this_dead_letter" {
  count                     = var.enable_dead_letter_queue ? 1 : 0
  name                      = "${var.queue_name}-dlq"
  message_retention_seconds = var.message_retention_seconds_dlq
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.this.arn]
  })
}

resource "aws_sqs_queue_redrive_policy" "this_dead_letter" {
  count     = var.enable_dead_letter_queue ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.this_dead_letter[count.index].arn
    maxReceiveCount     = var.max_receive_count_dlq
  })
}
