resource "aws_acm_certificate" "familiar_com" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}
