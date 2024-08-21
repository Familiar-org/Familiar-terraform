output "backend_ecr_repo_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "backend_alb_url" {
  value = aws_lb.backend.dns_name
}