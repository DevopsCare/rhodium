resource "aws_api_gateway_domain_name" "rhodium" {
  count = var.enable_apigw_domain ? 1 : 0

  certificate_arn = aws_acm_certificate_validation.api.certificate_arn
  domain_name     = "rhodium.${replace(data.aws_route53_zone.domain.name, "/[.]$/", "")}"
}

resource "aws_route53_record" "rhodium" {
  count = var.enable_apigw_domain ? 1 : 0

  name    = aws_api_gateway_domain_name.rhodium.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.domain.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.rhodium.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.rhodium.cloudfront_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = var.enable_apigw_domain ? 1 : 0

  api_id      = aws_api_gateway_rest_api.rhodium.id
  stage_name  = aws_api_gateway_stage.current.stage_name
  domain_name = aws_api_gateway_domain_name.rhodium.domain_name
  base_path   = "/"
}
