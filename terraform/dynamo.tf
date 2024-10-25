resource "aws_dynamodb_table" "this" {
  name         = var.dynamodb_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_type
  }
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.lambda_name}-dynamodb-policy"
  description = "Allows the Lambda function to perform CRUD operations on the DynamoDB table"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        Resource = aws_dynamodb_table.this.arn
      }
    ]
  })
}