terraform {
  backend "s3" {
   # Replace this with your bucket name!
   bucket         = "terraform-state-backend-14325"
   key            = "global/s3/vpc/terraform.tfstate"
   region         = "us-east-1"
  
    # Replace this with your DynamoDB table name!
      dynamodb_table = "terraform-state-backend-lock"
      encrypt        = true
    }
 }

