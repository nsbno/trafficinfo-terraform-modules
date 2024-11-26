variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "application_name" {
  description = "The name of the application -- used together with name_prefix."
  type        = string
}

variable "environment" {
  description = "Name of the environment, Ex. dev, test ,stage, prod."
  type        = string
}

variable "event_bus_name" {
  description = "Name of the EventBridge Bus to add Event rules for data to POST to ElasticCloud."
  type        = string
}

variable "cloudwatch_connection_arn" {
  description = "Name of Cloudwatch Event Connection used to POST data to ElasticCloud."
  type        = string
}

variable "elastic_hostname" {
  description = "Hostname of ElasticCloud where to POST data."
  type        = string
}

variable "data_to_elastic_event_rules" {
  description = "Create EventBridge rules to POST data to ElasticCloud for data matching."
  type = list(object({
    api_destination_name = string
    index_name           = string
    detail_type          = string
  }))
}