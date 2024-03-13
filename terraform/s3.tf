resource "aws_s3_bucket" "app_artifacts" {
  bucket = "${local.resource_prefix}-artifacts"

  tags = local.common_tags
}
