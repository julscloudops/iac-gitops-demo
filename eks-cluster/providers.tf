terraform {
  required_version = ">= 1.0.4"
  required_providers {

    aws = {
      version = ">= 2.28.1"
    }

    kubernetes = {
      version = "~> 1.13.4"
    }

    # random = {
    #   version = "~> 2.1"
    # }

    # local = {
    #   version = "~> 1.2"
    # }

    #   null = {
    #     version = "~> 2.1"
    #   }
  }
}



provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
