variable "aws_private_key_path" {
  description = <<DESCRIPTION
Path to the SSH private key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can 
connect.
Example: ~/.ssh/cloudops.pem
DESCRIPTION

}

variable "aws_key_name" {
  description = "Name of the AWS key pair"
}

variable "region" {
  default = "us-east-2"
}
