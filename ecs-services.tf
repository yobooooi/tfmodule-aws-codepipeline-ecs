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
    container_name       = "${var.team}-${var.service}-dev",
    container_port       = var.container_port,
    host_port            = var.host_port,
    reserved_task_memory = var.reserved_task_memory,
    log_group            = aws_cloudwatch_log_group.dev_ecs_log_group.name,
    environment_vars     = var.dev_ecs_environment_vars,
    secrets              = var.dev_ecs_ssm_secrets
  })
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  task_role_arn            = aws_iam_role.ecs_task_role_dev.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role_dev.arn
  placement_constraints {
    type = "memberOf"
    expression = "attribute:environment == dev"
  }
}

# resource "aws_ecs_service" "service" {
#   name            = "${var.environment_name}-${var.service_name}"
#   task_definition = "${aws_ecs_task_definition.service.family}:${max(aws_ecs_task_definition.service.revision, data.aws_ecs_task_definition.service_current.revision)}"

#   cluster         = aws_ecs_cluster.prod.id
#   launch_type     = "EC2"
#   desired_count   = var.container_desired_count

#   ordered_placement_strategy {
#     type  = "spread"
#     field = "attribute:ecs.availability-zone"
#   }

#   load_balancer {
#     target_group_arn = aws_alb_target_group.service_tg.arn
#     container_name   = "${var.environment_name}-${var.service_name}"
#     container_port   = var.container_port
#   }
# }