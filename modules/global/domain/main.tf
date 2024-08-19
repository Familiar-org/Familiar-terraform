# acm

resource "aws_acm_certificate" "familiar_link" {
  domain_name       = var.familiar_link_domain_name
  validation_method = "DNS"

  subject_alternative_names = [var.wildcard_familiar_link_domain_name]

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "familiar" {
  for_each = {
    for dvo in aws_acm_certificate.familiar_link.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
   # Skips the domain if it doesn't contain a wildcard
    if length(regexall("\\*\\..+", dvo.domain_name)) > 0
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.familiar.zone_id
}


# Route53

resource "aws_route53_zone" "familiar" {
  name = var.familiar_zone_name
}

resource "aws_route53_record" "familiar_a" {
  zone_id = aws_route53_zone.familiar.id
  name    = var.familiar_a_name
  type    = "A"

  alias {
    name                   = var.familiar_cf_alias_name
    zone_id                = aws_route53_zone.familiar.id
    evaluate_target_health = false
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "familiar_www_redirect" {
  zone_id = aws_route53_zone.familiar.id
  name    = "www"
  type    = "CNAME"
  records = [aws_route53_zone.familiar.name]
}
