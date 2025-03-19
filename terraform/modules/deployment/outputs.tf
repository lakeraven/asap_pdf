output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "database_url_secret_arn" {
  description = "ARN of the database URL secret"
  value       = aws_secretsmanager_secret.database_url.arn
}

output "rails_master_key_secret_arn" {
  description = "ARN of the Rails master key secret"
  value       = aws_secretsmanager_secret.rails_master_key.arn
}

output "redis_url_secret_arn" {
  description = "ARN of the Redis URL secret"
  value       = aws_secretsmanager_secret.redis_url.arn
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.app.name
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}
