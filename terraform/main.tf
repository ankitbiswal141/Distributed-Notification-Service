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

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

# Automated Helm Deployment via Terraform
resource "helm_release" "notify_engine" {
  name       = "notify-service"
  repository = "../deployments/helm/notify-chart"
  chart      = "notify-chart"
  namespace  = "production"
  create_namespace = true

  set {
    name  = "replicaCount"
    value = "3"
  }
}