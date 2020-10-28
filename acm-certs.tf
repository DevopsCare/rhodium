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
  for_each = {
    for dvo in aws_acm_certificate.rhodium[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.id
}

resource "aws_acm_certificate_validation" "api" {
  count = var.enable_apigw_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.rhodium[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  provider                = aws.aws-us-east-1
}
