resource "aws_api_gateway_rest_api" "this" {
  name        = var.name_api
  description = "API Gateway for Lambda"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = aws_api_gateway_resource.lambda_resource.id
  http_method          = aws_api_gateway_method.lambda_method.http_method
  type                 = "AWS_PROXY"
  cache_key_parameters = ["method.request.path.param"]
  cache_namespace      = "lambda-cache"
  timeout_milliseconds = 29000

  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
    {
    "body" : $input.json('$')
    }
    EOF
  }
}