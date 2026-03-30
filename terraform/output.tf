output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "argocd_server_url" {
  description = "The URL to access the ArgoCD UI"
  value       = "Check AWS LoadBalancer console for ArgoCD Service"
}