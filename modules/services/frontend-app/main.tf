resource "aws_s3_bucket" "frontend-app" {
  bucket = "${var.prefix}-frontend-app"
  tags = {
    Name = "${var.prefix}-frontend-app"
  }
}

resource "aws_s3_bucket_versioning" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "frontend-app" {
  bucket = aws_s3_bucket.frontend-app.id
  policy = data.aws_iam_policy_document.frontend-bucket-policy
  # policy에 뭐가 필요할까?
  # 일단 CF 허용해주는 폴리시 필요함
  # 그리고 data 블록을 이용해서 policy를 불러오는 것 확인 필요
  # 여러개의 policy를 
}

resource "aws_cloudfront_distribution" "frontend-app" {
  viewer_certificate {
    
  }
  origin {
    domain_name = 
  }
  default_cache_behavior {
    
  }
  restrictions {
    
  }
  enabled = 
}

resource "aws_cloudfront_cache_policy" "frontend-app" {
  parameters_in_cache_key_and_forwarded_to_origin {
    
  }
  name = 
}

resource "aws_cloudfront_origin_access_control" "frontend-app" {
  name = 
  origin_access_control_origin_type = 
  signing_protocol = 
  signing_behavior = 
}

resource "aws_cloudfront_response_headers_policy" "frontend-app" {
  name = 
}

data "aws_iam_policy_document" "frontend-bucket-policy" {
  
}