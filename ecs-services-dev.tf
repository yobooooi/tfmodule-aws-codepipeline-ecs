## TODO: tag sepcific tasks with respective environment

resource "aws_cloudwatch_log_group" "dev_ecs_log_group" {
  name = "dev/${var.service}"
}

resource "aws_ecs_task_definition" "dev_ecs_service" {
  family                   = "${var.team}-${var.service}-dev"
  container_definitions    = templatefile("${path.module}/templates/taskdefinition.tpl", {
    aws_region           = var.region,
    aws_account_id       = data.aws_caller_identity.current.account_id,
    service_name         = var.service,
    image                = aws_ecr_repository.repository.repository_url,
    container_name       = "${var.team}-${var.service}",
    container_port       = var.container_port,
    host_port            = var.host_port,
    reserved_task_memory = var.reserved_task_memory,
    log_group            = aws_cloudwatch_log_group.dev_ecs_log_group.name,
    environment_vars     = var.dev_ecs_environment_vars,
    secrets              = var.dev_ecs_ssm_secrets
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  #TODO: distinction between the task_role and execution_role. perhaps using a managad global execution role
  task_role_arn            = aws_iam_role.ecs_task_role_dev.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role_dev.arn
  cpu                      = 256
  memory                   = 512
}
resource "aws_ecs_service" "service" {
  name            = "${var.team}-${var.service}-dev"
  task_definition = aws_ecs_task_definition.dev_ecs_service.arn

  cluster         = data.aws_ecs_cluster.dev_cluster.arn
  desired_count   = var.dev_container_desired_count
  launch_type     = "FARGATE" 
  network_configuration {
    subnets         = [var.subnet_id1, var.subnet_id2, var.subnet_id3] 
    security_groups = [aws_security_group.ecs_service_sg.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service_tg_dev.arn
    container_name   = "${var.team}-${var.service}"
    container_port   = var.container_port
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.team}-${var.service}-sg"
  description = "all tcp inbound traffic from VPC"
  vpc_id      = data.aws_vpc.main.id

  ingress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [data.aws_vpc.main.cidr_block]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
}