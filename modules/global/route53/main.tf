resource "aws_route53_zone" "familiar" {
  name = var.route53_familiar_zone_name
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
  name    = var.familiar_cname_name
  type    = "CNAME"
  records = var.familiar_cname_record
}
