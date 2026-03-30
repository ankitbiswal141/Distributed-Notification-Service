# Standard VPC setup for our Microservice
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "notification-engine-vpc" }
}

# EKS Cluster (Kubernetes)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "notification-cluster"
  cluster_version = "1.28"

  vpc_id     = aws_vpc.main.id
  subnet_ids = ["<Replace this with your subnet id>"] 

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 5
      instance_types = ["t3.medium"]     # Replace this with your instance type
    }
  }
}