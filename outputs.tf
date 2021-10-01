output "repository_id" {
  value = aws_codecommit_repository.repository.repository_id
}

output "repository_clone_url_ssh" {
  value = aws_codecommit_repository.repository.clone_url_ssh
}

output "codepipeline_id" {
  value = aws_codepipeline.pipeline.id
}

output "codebuild_id" {
  value = aws_codebuild_project.build.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repository.repository_url
}

output "ecs_dev_taskdefinition" {
  value = jsonencode(templatefile("${path.module}/templates/taskdefinition.tpl", {
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
  }))
}