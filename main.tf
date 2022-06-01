
provider "aws" {
  region = "us-east-1"
  alias  = "aws_cloudfront"
}


provider "aws" {
  region = "us-east-1"
}


module "cloudfront_s3_assets" {
  source             = "./config"
  domain_name        = "midas-capital-assets"
}

