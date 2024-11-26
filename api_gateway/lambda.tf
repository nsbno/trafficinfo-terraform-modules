#####################
# The Lambda config
#####################

resource "aws_lambda_permission" "this" {
  count         = var.lambda_config == null ? 0 : 1
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_config.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  qualifier     = var.lambda_config.lambda_qualifier

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*"
}
