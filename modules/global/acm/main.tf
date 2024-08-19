resource "aws_acm_certificate" "familiar_com" {
  domain_name       = var.familiar_com_domain_name
  validation_method = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}
