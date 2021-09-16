variable "aws_region" {
  description = "AWS region where launch servers"
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "aws profile"
  default     = "terraform"
}

variable "aws_amis" {
  default = {
    us-east-2 = "ami-05ef7cf990d4d70bd"
  }
}

variable "elk_instance_type" {
  default = "t2.micro"
}

variable "aws_private_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/cloudops.pem
DESCRIPTION

}

variable "aws_key_name" {
  description = "Name of the AWS key pair"
}

variable "elasticsearch_data_dir" {
  default = "/opt/elasticsearch/data"
}
variable "elasticsearch_cluster" {
  description = "Name of the elasticsearch cluster"
  default     = "elastic_cluster"
}




