
resource "aws_cloudwatch_metric_alarm" "sqs_queue_oldest_message_age" {
  alarm_name          = "${var.queue_name}-oldest-message-age"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = 300
  alarm_description   = "Alarm when the age of the oldest message in the SQS queue is greater than 5 minutes"
  dimensions = {
    QueueName = aws_sqs_queue.this.name
  }
  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "sqs_dlq_messages_visible" {
  count               = var.enable_alarms && var.enable_dead_letter_queue ? 1 : 0
  alarm_name          = "${var.queue_name}-dlq-messages-visible"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alarm when there is at least 1 message visible in the dead letter queue"
  dimensions = {
    QueueName = aws_sqs_queue.this_dead_letter[count.index].name
  }
  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
}
