output "api_arn" {
  value = aws_api_gateway_rest_api.this.arn
}

output "api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "stage_name" {
  value = aws_api_gateway_stage.this.stage_name
}