output "vpc_id" {
  description = "Devops VPC ID"
  value       = aws_vpc.devops_vpc.id
}


output "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  value       = aws_subnet.public_subnet_1.id
}


output "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  value       = aws_subnet.public_subnet_2.id
}


output "security_group_id" {
  description = " security group ID"
  value       = aws_security_group.devops_sg.id
}


output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.devops_app.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS Kubernetes version"
  value       = module.eks.cluster_version
}

output "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "eks_node_security_group_id" {
  description = "EKS node security group ID"
  value       = module.eks.node_security_group_id
}

