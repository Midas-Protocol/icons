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
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = var.domain_name
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = var.domain_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "dist" {
  for_each = fileset("${path.module}/../token/", "*")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = "token/${each.value}"
  source   = "${path.module}/../token/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("${path.module}/../token/${each.value}")
}

resource "aws_s3_object" "dist_32x32" {
  for_each = fileset("${path.module}/../token/32x32/", "*")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = "token/32x32/${each.value}"
  source   = "${path.module}/../token/32x32/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("${path.module}/../token/32x32/${each.value}")
}

resource "aws_s3_object" "dist_96x96" {
  for_each = fileset("${path.module}/../token/96x96/", "*")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = "token/96x96/${each.value}"
  source   = "${path.module}/../token/96x96/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("${path.module}/../token/96x96/${each.value}")
}


resource "aws_s3_object" "social" {
  for_each = fileset("${path.module}/../social/", "*")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = "social/${each.value}"
  source   = "${path.module}/../social/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("${path.module}/../social/${each.value}")
}

resource "aws_s3_object" "network" {
  for_each = fileset("${path.module}/../network/", "*")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = "network/${each.value}"
  source   = "${path.module}/../network/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("${path.module}/../network/${each.value}")
}
