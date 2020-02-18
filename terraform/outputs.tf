output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "external-endpoint" {
  value = "https://${aws_route53_record.app.name}"
}