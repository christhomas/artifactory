resource "aws_cloudwatch_log_group" "logs" {
  name              = "/${var.squad}/${var.app_name}"
  retention_in_days = "14"
  tags              = "${var.tags}"
}
