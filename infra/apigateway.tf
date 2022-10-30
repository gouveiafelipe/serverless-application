resource "aws_api_gateway_rest_api" "gateway" {
  name = var.service_name
}

resource "aws_api_gateway_resource" "v1" {
  parent_id   = aws_api_gateway_rest_api.gateway.root_resource_id
  path_part   = "v1"
  rest_api_id = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_resource" "create" {
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "create"
  rest_api_id = aws_api_gateway_rest_api.gateway.id
}

#TODO COGNITO USER POOLS
#resource "aws_api_gateway_authorizer" "authorizer" {
#  name        = ""
#  rest_api_id = aws_api_gateway_rest_api.gateway.id
#}

resource "aws_api_gateway_method" "any" {
  authorization = "NONE" #TODO  AFTER CREATING COGNITO THIS WILL BE THE AUTHORIZER ID ABOVE
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.create.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_integration" "integration" {
  http_method             = aws_api_gateway_method.any.http_method
  resource_id             = aws_api_gateway_resource.create.id
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  stage_name  = "dev"
  depends_on  = [aws_api_gateway_integration.integration]
}


