data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${local.lambda_path}/lambda_function.py"
  output_path = "files/lambda_function.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "lambda-apg-integration"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.role.arn
  runtime          = "python3.7"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.gateway.id}/*/${aws_api_gateway_method.any.http_method}${aws_api_gateway_resource.create.path}"
}

#resource "aws_lambda_permission" "lambda_permission" {
#  statement_id  = "AllowMyDemoAPIInvoke"
#  action        = "lambda:InvokeFunction"
#  function_name = "MyDemoFunction"
#  principal     = "apigateway.amazonaws.com"
#
#  # The /*/*/* part allows invocation from any stage, method and resource path
#  # within API Gateway REST API.
#  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*/*"
#}

#resource "aws_lambda_permission" "dynamo" {
#  statement_id  = "AllowExecutionFromAPIGateway"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.lambda.function_name
#  principal     = "apigateway.amazonaws.com"
#  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
#}

resource "aws_iam_role" "role" {
  name = "myrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}