# terraform/outputs.tf

output "region" {
  description = "The AWS region."
  value       = var.region
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "db_instance_address" {
  description = "The address of the RDS instance."
  value       = aws_db_instance.default.address
}

output "db_instance_username" {
  description = "The username for the RDS database."
  value       = aws_db_instance.default.username
  sensitive   = true
}


output "db_password" {
  description = "The password for the RDS database."
  value       = var.db_password
  sensitive   = true
}
# -----------------------

output "frontend_ecr_url" {
  description = "The URL of the frontend ECR repository."
  value       = aws_ecr_repository.frontend.repository_url
}

output "backend_ecr_url" {
  description = "The URL of the backend ECR repository."
  value       = aws_ecr_repository.backend.repository_url
}

output "github_actions_iam_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions."
  value       = aws_iam_role.github_actions_role.arn
}
