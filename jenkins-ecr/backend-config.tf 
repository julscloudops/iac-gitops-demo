terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

# Creates the S3 to store the remote state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "backend-state1234"
  # Enable versioning so we can see the full revision history of our 
  # state files

  versioning {
    enabled = true
  }

  # Enable server-side encryption by default

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#Creates the DynamoDB table to permit the lock during terraform apply
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "backend-state-lock1234"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

