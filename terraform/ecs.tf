### ECS

resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.squad}-${var.app_name}"

  tags = "${var.tags}"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.squad}-${var.app_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  execution_role_arn       = "${aws_iam_role.execution.arn}"
  task_role_arn            = "${aws_iam_role.task.arn}"

  tags                     = "${var.tags}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "${var.squad}_${var.app_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ],
    "ulimits": [
      {
        "softLimit": 10000,
        "hardLimit": 10000,
        "name": "nofile"
      }
    ],
    "environment": [
      {
        "name": "DB_TYPE",
        "value": "mysql"
      },{
        "name": "DB_HOST",
        "value": "${aws_db_instance.default.address}"
      },{
        "name": "DB_NAME",
        "value": "${var.app_name}"
      },{
        "name": "DB_USER",
        "value": "${var.app_name}"
      },{
        "name": "DB_PASSWORD",
        "value": "${var.app_name}"
      },{
        "name": "MASTER_KEY",
        "value": "${var.master_key}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/${var.squad}/${var.app_name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "${var.squad}-${var.app_name}"
  cluster         = "${aws_ecs_cluster.app_cluster.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs.id}"]
    subnets         = "${aws_subnet.private.*.id}"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app_target_group.id}"
    container_name   = "${var.squad}_${var.app_name}"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_listener.https",
  ]
}