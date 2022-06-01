
provider "aws" {
  region = "us-east-1"
  alias  = "aws_cloudfront"
}


provider "aws" {
  region = "us-east-1"
}


module "cloudfront_s3_assets" {
  source             = "./"
  domain_name        = var.domain_name // Any random identifier for s3 bucket name
  use_default_domain = true
  upload_files       = true
  tags               = var.tags
}

