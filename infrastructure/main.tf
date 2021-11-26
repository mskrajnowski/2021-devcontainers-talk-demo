locals {
  project = "devcontainers-demo"
}

resource "aws_s3_bucket" "web_app" {
  bucket = "${local.project}-web-app"
}

module "cloudfront_origin_web_app" {
  source = "github.com/codequest-eu/terraform-modules?ref=9178da5//cloudfront/origin/s3"

  bucket = aws_s3_bucket.web_app.bucket
}

module "cloudfront_behavior_web_app" {
  source = "github.com/codequest-eu/terraform-modules?ref=9178da5//cloudfront/behavior"

  origin_id = "web_app"
}

module "cloudfront" {
  source = "github.com/codequest-eu/terraform-modules?ref=9178da5//cloudfront"

  s3_origins       = { web_app = module.cloudfront_origin_web_app }
  default_behavior = module.cloudfront_behavior_web_app

  error_responses = {
    404 = { response_code = 200, response_path = "/index.html" }
  }
}

module "bucket_policy_document_web_app" {
  source = "github.com/codequest-eu/terraform-modules?ref=9178da5//cloudfront/origin/s3/bucket_policy_document"

  bucket_arn           = aws_s3_bucket.web_app.arn
  access_identity_arns = [module.cloudfront.access_identity_arn]
}

resource "aws_s3_bucket_policy" "web_app" {
  bucket = aws_s3_bucket.web_app.bucket
  policy = module.bucket_policy_document_web_app.json
}

output "web_app_bucket" {
  value = aws_s3_bucket.web_app.bucket
}

output "cloudfront_url" {
  value = module.cloudfront.url
}
