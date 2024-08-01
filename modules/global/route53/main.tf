resource "aws_route53_zone" "familiar" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.familiar.id
  name    = var.web_record_name
  type    = "A"
  alias {
    name = # 나중에 기입
    zone_id = aws_route53_zone.familiar.id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_redirect" {
  zone_id = aws_route53_zone.familiar.id
  name    = var.www_redirect_record_name
  type    = "CNAME"
  records = var.www_redirect_record
}
