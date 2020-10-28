/*
* Copyright (c) 2020 Risk Focus Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

resource "aws_acm_certificate" "rhodium" {
  count = var.enable_apigw_domain ? 1 : 0

  domain_name       = "rhodium.${data.aws_route53_zone.domain.name}"
  validation_method = "DNS"
  provider          = aws.aws-us-east-1
}

resource "aws_route53_record" "cert_validation" {
  count = var.enable_apigw_domain ? 1 : 0

  name    = aws_acm_certificate.rhodium[0].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.rhodium[0].domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.domain.id
  records = [aws_acm_certificate.rhodium[0].domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "api" {
  count = var.enable_apigw_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.rhodium[0].arn
  validation_record_fqdns = [aws_route53_record.cert_validation[0].fqdn]
  provider                = aws.aws-us-east-1
}
