data "aws_route53_zone" "root_domain" {
  name         = "${var.root_domain_name}"
  private_zone = false
}

resource "aws_route53_record" "app" {
  zone_id = "${data.aws_route53_zone.root_domain.zone_id}"
  name    = "${var.project_subrecord}.${var.root_domain_name}"
  type    = "A"

  alias {
    name                    = "${aws_alb.main.dns_name}"
    zone_id                 = "${aws_alb.main.zone_id}"
    evaluate_target_health  = true
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${aws_route53_record.app.name}"
  validation_method = "DNS"

  tags = "${var.tags}"
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_record.app.zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]

  timeouts {
    create = "45m"
  }
}