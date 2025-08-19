output "s3_bucket_name" {
  description = "The name of the S3 bucket for the frontend."
  value       = aws_s3_bucket.frontend.bucket
}

output "s3_website_endpoint" {
  description = "The website endpoint for the S3 bucket."
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "ecr_frontend_repo_url" {
  description = "The URL of the ECR repository for the frontend."
  value       = aws_ecr_repository.frontend.repository_url
}

output "ecr_backend_repo_url" {
  description = "The URL of the ECR repository for the backend."
  value       = aws_ecr_repository.backend.repository_url
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database."
  value       = aws_db_instance.default.endpoint
  sensitive   = true
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.main.name
}
