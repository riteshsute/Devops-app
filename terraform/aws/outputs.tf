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
