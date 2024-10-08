# log bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
}

resource "aws_s3_bucket_policy" "lob_bucket_policy" {
  policy = 
  bucket = aws_s3_bucket.log_bucket
}