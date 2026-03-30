variable "aws_region" {
  description = "Target AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "devops-portal-eks"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "argocd_version" {
  description = "Helm chart version for ArgoCD"
  type        = string
  default     = "5.46.7"
}

variable "environment" {
  type    = string
  default = "production"
}