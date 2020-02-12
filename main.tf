data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_route53_zone" "domain" {
  name = var.domain
}
