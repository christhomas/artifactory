/*
 * Create DB Subnet Group for private subnets
 */
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${lower(var.squad)}-${lower(var.app_name)}-subnet"
  subnet_ids = "${aws_subnet.private.*.id}"
}

resource "aws_db_instance" "default" {
  name                      = "artdb"
  identifier                = "${lower(var.squad)}-${lower(var.app_name)}"
  username                  = "${var.app_name}"
  password                  = "${var.app_name}"
  port                      = 3306
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  allocated_storage         = 20
  storage_encrypted         = false
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.db_subnet_group.name}"
  parameter_group_name      = "default.mysql5.7"
  storage_type              = "gp2"
  publicly_accessible       = false
  final_snapshot_identifier = "${lower(var.squad)}-${lower(var.app_name)}-backup"
  skip_final_snapshot       = true
}