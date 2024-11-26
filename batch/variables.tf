variable "current_account" {
  description = "Account id of the current account"
  type        = string
}

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "job_name" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "job_image" {
  description = "Container image for job"
  type        = string
}

variable "job_command" {
  description = "Container command to run"
  type        = list(string)
}

variable "job_environment" {
  description = "Environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "job_resource_requirements" {
  description = "Resource requirements"
  type = list(object({
    type  = string
    value = string
  }))
  default = []
}

variable "compute_environment_arn" {
  description = "A prefix used for naming resources."
  type        = string
}
