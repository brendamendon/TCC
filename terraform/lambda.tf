resource "aws_lambda_function" "test_lambda" {
  filename      = var.filename
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler

  source_code_hash = var.hash == null ? filebase64sha256(var.filename) : var.hash

  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_name
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = var.name_iam_role == "" ? "${var.lambda_name}-role" : var.name_iam_role
  assume_role_policy = var.assume_role_policy
}