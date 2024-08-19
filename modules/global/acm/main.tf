resource "aws_acm_certificate" "familiar_link" {
  domain_name       = var.familiar_link_domain_name
  validation_method = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}
