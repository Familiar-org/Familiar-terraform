resource "aws_s3_bucket" "frontend-app" {
  bucket = "${var.prefix}-frontend-app"
  tags = {
    Name = "${var.prefix}-frontend-app"
  }
}

resource "aws_s3_bucket_acl" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  acl = "public-read"
}

resource "aws_s3_bucket_versioning" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  versioning_configuration {
    status = var.s3_versioning
  }
}

resource "aws_s3_bucket_policy" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  policy = data.aws_iam_policy_document.frontend-bucket-policy
}

resource "aws_cloudfront_distribution" "frontend-app" {
  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = # 나중에 기입
    minimum_protocol_version = "TLSv1.2_2021"
  }
  origin {
    domain_name = aws_s3_bucket.frontend-app.bucket_regional_domain_name
    origin_id = var.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend-app.id
  }
  default_cache_behavior {
    target_origin_id = aws_s3_bucket.frontend-app.id
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
  }
  aliases = var.env == "dev" ? ["dev.familiar.link"] : ["familiar.link","www.familiar.link"]
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  default_root_object = "index.html"
  enabled = true
  tags = {
    Name = "${var.prefix}"
  }
}

resource "aws_cloudfront_cache_policy" "frontend-app" {
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = 
    }
    headers_config {
      
    }
    query_strings_config {
      query_string_behavior = 
    }
  }
  name = 
}

resource "aws_cloudfront_origin_access_control" "frontend-app" {
  name = 
  origin_access_control_origin_type = "s3"
  signing_protocol = "sigv4"
  signing_behavior = "always"
}

resource "aws_cloudfront_response_headers_policy" "frontend-app" {
  name = 
}
