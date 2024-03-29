terraform {

  cloud {
    organization = "QATIP"

    workspaces {
      name = "lab6-workspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }

  required_version = ">= 1.1.0"
}

data "terraform_remote_state" "eks" {
  backend = "remote"
   config = {
    organization = "QATIP" # Change this to match the organisation created earlier
    workspaces = {
      name = "lab6-workspace" # Change this to match the workspace created earlier
  }
}
}
# Retrieve EKS cluster information

data "aws_eks_cluster" "cluster" {
  name = "my-eks-cluster"
}

output "endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}