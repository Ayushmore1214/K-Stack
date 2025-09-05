output "region" {
  value = var.region
}
output "cluster_name" {
  value = module.eks.cluster_name
}
output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend.repository_url
}
output "backend_ecr_url" {
  value = aws_ecr_repository.backend.repository_url
}
output "github_actions_iam_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}
output "db_instance_address" {
  value = aws_db_instance.default.address
}
output "db_instance_username" {
  value     = aws_db_instance.default.username
  sensitive = true
}
output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}