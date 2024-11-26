resource "aws_api_gateway_rest_api" "this" {
  description = var.api_description
  name        = var.api_name
  body        = var.api_shcema
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha256(var.api_shcema)
  }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "v1"
  deployment_id = aws_api_gateway_deployment.this.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this_access_log.arn
    format = file("../static/logs/access_log_format.json")
  }

  variables = {
    hash = sha256(var.api_shcema)
  }
  cache_cluster_enabled = var.cache_config.enabled
  cache_cluster_size    = var.cache_config.enabled ? var.cache_config.size_in_gb : null
}

resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = "services.${var.hosted_zone_name}"
  base_path   = var.base_path
}

resource "aws_cloudwatch_log_group" "this_access_log" {
  name              = "API-Gateway-${var.api_name}-access-log"
  retention_in_days = var.access_log_retention_days
}
resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled      = true
    logging_level        = "INFO"
    caching_enabled      = var.cache_config.enabled
    cache_ttl_in_seconds = var.cache_config.enabled ? var.cache_config.ttl_in_seconds : null
  }
}
