resource "aws_acm_certificate" "rhodium" {
  count = var.enable_apigw_domain ? 1 : 0

  domain_name       = "rhodium.${data.aws_route53_zone.domain.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  count = var.enable_apigw_domain ? 1 : 0

  name    = aws_acm_certificate.rhodium.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.rhodium.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.domain.id
  records = [aws_acm_certificate.rhodium.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "api" {
  count = var.enable_apigw_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.rhodium.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
