###############################################
# create AWS Batch Job and Job Queue.
#
########################
resource "aws_batch_job_definition" "batch_job_definition" {
  name = replace("${var.name_prefix}_${var.job_name}_definition", "_", "-")
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    command    = var.job_command
    image      = var.job_image
    jobRoleArn = aws_iam_role.ecs_task_execution_role.arn

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    environment          = var.job_environment
    resourceRequirements = var.job_resource_requirements
    executionRoleArn     = aws_iam_role.ecs_task_execution_role.arn
  })
}

resource "aws_batch_job_queue" "job_queue" {
  name = replace("${var.name_prefix}_${var.job_name}-queue", "_", "-")
  state    = "ENABLED"
  priority = 1

  compute_environments = [var.compute_environment_arn]
}