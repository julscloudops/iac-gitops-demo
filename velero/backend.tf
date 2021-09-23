terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "backend-state1234"
    key    = "velero/terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "backend-state-lock1234"
    encrypt        = true
  }
}
