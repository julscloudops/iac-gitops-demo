provider "aws" {
  region = var.region
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "backend-state1234"
    key    = "eks-cluster/terraform.tfstate"
    region = "us-east-2"
  }
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

  resource "kubernetes_namespace" "demo_app" {
  metadata {
    name = "demo-app"
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.demo_app.id
    labels = {
      app = var.application_name
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = var.application_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }
      spec {
        container {
          image = "gcr.io/google-samples/microservices-demo/frontend:v0.2.4"
          name  = var.application_name
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.demo_app.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.frontend.metadata[0].labels.app
    }
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
