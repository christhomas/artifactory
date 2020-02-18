### ALB
resource "aws_alb" "main" {
  name            = "${var.squad}-${var.app_name}"
  subnets         = "${aws_subnet.public.*.id}"
  security_groups = ["${aws_security_group.alb.id}"]
  tags            = "${var.tags}"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "https" {
  depends_on = ["aws_acm_certificate_validation.cert"]

  load_balancer_arn = "${aws_alb.main.id}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${aws_acm_certificate.cert.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.app_target_group.id}"
    type             = "forward"
  }
}

# Redirect http -> https
resource "aws_alb_listener" "http" {
  depends_on = [
    "aws_alb.main",
    "aws_alb_target_group.app_target_group"
  ]

  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_target_group" "app_target_group" {
  name        = "${var.squad}-${var.app_name}"
  port        = "${var.app_port}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.main.id}"
  target_type = "ip"
  tags        = "${var.tags}"
}

