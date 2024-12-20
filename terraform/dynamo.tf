resource "aws_dynamodb_table" "this" {
  name         = var.dynamodb_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_type
  }
}