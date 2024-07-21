# --------------------------------------
# Certificate Manager
# --------------------------------------
# acm
resource "aws_acm_certificate" "certificte" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-sslcert"
    Project = var.project
    Env     = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_route53_zone.route53_zone
  ]
}

# acm dns resolve
resource "aws_route53_record" "route53_acm_dns_resolve" {
  for_each = {
    for s in aws_acm_certificate.certificte.domain_validation_options : s.domain_name => {
      name   = s.resource_record_name
      type   = s.resource_record_type
      record = s.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.route53_zone.id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  records         = [each.value.record]
}

# acm validation
resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.certificte.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_acm_dns_resolve : record.fqdn]
}