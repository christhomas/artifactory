resource "aws_s3_bucket" "bucket" {
  bucket = "${lower(var.squad)}-${lower(var.app_name)}"
  acl    = "private"

  tags = {
    Name        = "Artifactory Data Store"
    squad = "${var.squad}"
  }
}
