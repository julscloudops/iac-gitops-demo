
#The bucket and the key place is hardcoded

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Data Blocks

data "terraform_remote_state" "demo_vpc" {
    backend = "s3"
    config = {
        bucket  = "backend-state1234"
        key     = "demo-vpc/terraform.tfstate"
        region  = "us-east-2"
    }
}

data "aws_ami" "redhat" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-7.5_HVM_GA*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["309956199498"]
}

# resource block
resource "aws_instance" "jenkins" {
  # subnet_id              = aws_subnet.public_subnet.id
  ami                    = data.aws_ami.redhat.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_traffic.id]
  key_name               = var.aws_key_name

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y jenkins java-11-openjdk-devel",
      "sudo yum -y install wget",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade -y",
      "sudo yum install jenkins -y",
      "sudo systemctl start jenkins",
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file(var.aws_private_key_path)

    }

  }
}
