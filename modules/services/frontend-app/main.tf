locals {
  default_cf_min_ttl     = 0
  default_cf_max_ttl     = 360
  default_cf_default_ttl = 60
}

# S3 bucket
resource "aws_s3_bucket" "frontend-app" {
  bucket = "${var.prefix}-frontend-app"
  tags = {
    Name = "${var.prefix}-frontend-app"
  }
}

resource "aws_s3_bucket_ownership_controls" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "frontend-app" {
  depends_on = [aws_s3_bucket_ownership_controls.frontend-app]

  bucket = aws_s3_bucket.frontend-app.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  versioning_configuration {
    status = var.prefix == "familiar-dev" ? "Disabled" : "Enabled"
  }
}

resource "aws_s3_bucket_policy" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  policy = data.aws_iam_policy_document.frontend-app-bucket-policy.json
}

data "aws_iam_policy_document" "frontend-app-bucket-policy" {
  # oac allow policy
  statement {
    sid = "allowOacPolicy"

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources = [
      "${aws_s3_bucket.frontend-app.arn}/*",
      "${aws_s3_bucket.frontend-app.arn}/"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.frontend-app.arn}"]
    }
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "frontend-app" {
  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.familiar_com_acm_id
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  origin {
    domain_name              = aws_s3_bucket.frontend-app.bucket_domain_name
    origin_id                = aws_s3_bucket.frontend-app.id
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend-app.id
  }

  origin {
    origin_id   = var.alb_origin_id
    domain_name = "${aws_s3_bucket.frontend-app.bucket_domain_name}/api"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https_only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.frontend-app.id
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = local.default_cf_min_ttl
    max_ttl     = local.default_cf_max_ttl
    default_ttl = local.default_cf_default_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_root_object = "index.html"
  enabled             = true
  aliases             = var.prefix == "familiar-dev" ? ["dev.familiar.link"] : ["familiar.link", "www.familiar.link"]
  is_ipv6_enabled     = false
  http_version        = "http2"
  price_class         = "PriceClass_200"

  tags = {
    Name = "${var.prefix}-cf-distribution-familiar"
  }
}

resource "aws_cloudfront_origin_access_control" "frontend-app" {
  name                              = "${var.prefix}-frontend-cf-oac"
  description                       = "cloudfront to frontend s3 oac"
  origin_access_control_origin_type = "s3"
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
}
