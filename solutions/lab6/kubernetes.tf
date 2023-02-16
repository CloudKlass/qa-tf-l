    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
 

# 'Required Version' would be here in the cloud.tf file

data "terraform_remote_state" "eks" {
  backend = "remote"
   config = {
    organization = "TestOrg-QATIP" # Change this to match the organisation created earlier
    workspaces = {
      name = "lab6-workspace" # Change this to match the workspace created earlier
  }
}
}
# Retrieve EKS cluster information

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
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