output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecs_task_execution_role.name
}

output "job_queue_arn" {
  value = aws_batch_job_queue.job_queue.arn
}

output "job_arn" {
  value = aws_batch_job_definition.batch_job_definition.arn
}