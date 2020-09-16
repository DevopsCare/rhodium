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

resource "aws_api_gateway_domain_name" "rhodium" {
  count = var.enable_apigw_domain ? 1 : 0

  certificate_arn = aws_acm_certificate_validation.api[0].certificate_arn
  domain_name     = "rhodium.${replace(data.aws_route53_zone.domain.name, "/[.]$/", "")}"
}

resource "aws_route53_record" "rhodium" {
  count = var.enable_apigw_domain ? 1 : 0

  name    = aws_api_gateway_domain_name.rhodium[0].domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.domain.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.rhodium[0].cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.rhodium[0].cloudfront_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = var.enable_apigw_domain ? 1 : 0

  api_id      = aws_api_gateway_rest_api.rhodium.id
  stage_name  = aws_api_gateway_stage.current.stage_name
  domain_name = aws_api_gateway_domain_name.rhodium[0].domain_name
  base_path   = ""
}
