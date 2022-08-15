module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # vpc defined in main.tf
  vpc_id     = aws_vpc.Lab6_VPC.id
  # subnet_ids = ["subnet-0934ac623b8426b1c", "subnet-09a711bf99d194017"] :- a list of subnet IDs for provisioning
  
  # Dynamic list of subnet IDs
  subnet_ids = aws_subnet.privatesubnets[*].id #Use of Splat
  
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t2.micro", "t3.micro", "t3.medium"]
  }

  eks_managed_node_groups = {
      Prod = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "QATIP"
    Lab   = "lab6"
  }
}