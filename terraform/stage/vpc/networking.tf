provider "aws" {
 region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"
  name = "staging-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  public_subnet_tags = {
    Name = "staging-public-subnet"
  }

  tags = {
    Owner       = "user"
    Environment = "staging"
  }

  vpc_tags = {
    Name = "staging-vpc"
  }
}
