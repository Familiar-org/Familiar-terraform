locals {
  arn_format = "arn:aws:s3:::"
}

# log bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  tags = {
    Name = var.log_bucket_name
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "lob_bucket" {
  policy = data.aws_s3_bucket_policy.log_bucket
  bucket = aws_s3_bucket.log_bucket.id
}

# Allow vpc flow log policy
data "aws_iam_policy_document" "log_bucket_policy" {
  statement {
    sid    = "logDeliveryPut"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${local.arn_format}${var.log_bucket_name}/*"
    ]
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    sid    = "logDeliveryAclCheck"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "${local.arn_format}${var.log_bucket_name}"
    ]
    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

