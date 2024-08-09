resource "aws_acm_certificate" "familiar_com" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = var.domain_tag_env
  }

  lifecycle {
    prevent_destroy = true
  }
}
