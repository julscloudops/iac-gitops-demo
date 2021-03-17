terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  #This block requires the S3 bucket and the DynamoDB table to exist
  # It configures the terraform backend to store it's state on the S3 bucket

  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-state-backend-14325"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-backend-lock"
    encrypt        = true
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

