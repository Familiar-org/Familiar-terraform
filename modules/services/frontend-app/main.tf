resource "aws_cloudfront_distribution" "name" {
  viewer_certificate {
    
  }
  origin {
    
  }
  default_cache_behavior {
    
  }
  restrictions {
    
  }
  enabled = 
}

resource "aws_cloudfront_cache_policy" "name" {
  parameters_in_cache_key_and_forwarded_to_origin {
    
  }
  name = 
}

resource "aws_cloudfront_origin_access_control" "name" {
  name = 
  origin_access_control_origin_type = 
  signing_protocol = 
  signing_behavior = 
}

resource "aws_cloudfront_response_headers_policy" "name" {
  name = 
}

resource "aws_s3_bucket" "name" {
  

}

resource "aws_s3_bucket_versioning" "name" {
  versioning_configuration {
    
  }
  bucket = 
}

resource "aws_s3_bucket_policy" "name" {
  policy = 
  bucket = 
}