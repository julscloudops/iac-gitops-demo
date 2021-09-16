terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.44.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.9"
    }
  }

  required_version = "> 0.13.1"
}

