data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.domain_name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
      ]
    }
  }
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.domain_name
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = var.domain_name
  acl = "private"
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = var.domain_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object" "dist" {
  for_each = fileset("${path.module}/../token/", "*")
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = each.value
  source = "${path.module}/../token/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag   = filemd5("${path.module}/../token/${each.value}")
}
