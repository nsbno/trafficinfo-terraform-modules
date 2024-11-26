variable "api_shcema" {
  description = "The OpenAPI schema of the API Gateway"
  type        = string
}

variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "base_path" {
  description = "The base path of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "The description of the API Gateway"
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
}

variable "lambda_config" {
  description = "Specify this if the apigateway is having a lambda backend. The configuration of the Lambda function that is triggered by the API Gateway"
  type = object({
    lambda_function_name = string
    lambda_qualifier     = string // the reference to the alias or version to trigger
  })
  default = null
}

variable "access_log_retention_days" {
  description = "How long to store the access logs"
  type        = number
  default     = 14
}

variable "cache_config" {
  description = "The configuration of the cache"
  type = object({
    enabled = optional(bool, false)
    ttl_in_seconds = optional(number, 3600)
    size_in_gb = optional(number, 0.5)
  })
}