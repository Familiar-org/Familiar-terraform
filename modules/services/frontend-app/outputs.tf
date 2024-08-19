output "cf_alias_name" {
  value = aws_cloudfront_distribution.frontend-app.domain_name
}
