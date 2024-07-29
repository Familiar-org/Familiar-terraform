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
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  policy = data.aws_iam_policy_document.frontend-bucket-policy
}

resource "aws_cloudfront_distribution" "frontend-app" {
  viewer_certificate {
    
  }
  origin {
    domain_name = aws_s3_bucket.frontend-app.bucket_regional_domain_name
    origin_id = var.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend-app.id
  }
  default_cache_behavior {
    target_origin_id = aws_s3_bucket.frontend-app.id
    cached_methods = 
    allowed_methods = 
    viewer_protocol_policy = 
  }
  aliases = ["familiar.link","www.famialiar.link"]
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  enabled = true
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

data "aws_" "name" {
  
}