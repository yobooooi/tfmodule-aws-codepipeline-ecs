data "aws_caller_identity" "current" {}

data "template_file" "codebuild_service_role" {
  template = file("${path.module}/templates/service_assume_role.tpl")

  vars = {
    service = "codebuild.amazonaws.com"
  }
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/templates/codebuild_policy.tpl")

  vars = {
    service_name   = var.service

    aws_region     = var.region
    aws_account_id = data.aws_caller_identity.current.account_id
    
    subnet_id1     = var.subnet_id1
    subnet_id2     = var.subnet_id2
    subnet_id3     = var.subnet_id3
  }
}

data "template_file" "buildspec" {
  template = file("${path.module}/templates/buildspec.tpl")

  vars = {
    runtime_version         = var.runtime_version
    container_name          = var.service
    repository_url          = aws_ecr_repository.repository.repository_url
    region                  = var.region
    aws_account_id          = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "codepipeline_service_role" {
  template = file("${path.module}/templates/service_assume_role.tpl")

  vars = {
    service = "codepipeline.amazonaws.com"
  }
}

data "template_file" "codepipeline_policy" {
  template = file("${path.module}/templates/codepipeline_policy.tpl")

  vars = {
    codebuild_arn  = aws_codebuild_project.build.arn
    bucket_arn     = data.aws_s3_bucket.codebuild_artifacts.arn
    codecommit_arn = aws_codecommit_repository.repository.arn
  }
}

data "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "codepipeline-eu-west-1-790564679168"
}

# data "local_file" "local_file_service_taskdefinition_dev_copy" {
#   content = jsonencode(templatefile("${path.module}/templates/taskdefinition_copy.tpl", {
#     image                = "test01"
#     container_name       = "${var.team}-${var.service}-dev",
#     container_port       = var.container_port,
#     host_port            = var.host_port,
#     reserved_task_memory = var.reserved_task_memory
#   }))
#   filename = "${path.module}/templates/taskdefinition_dev_rendered.json"
# }




# data "local_file" "local_file_service_taskdefinition_dev" {
#   content = jsonencode(templatefile("${path.module}/templates/taskdefinition.tpl", {
#     aws_region           = var.region,
#     aws_account_id       = data.aws_caller_identity.current.account_id,
#     environment_name     = "dev",
#     service_name         = var.service,
#     image                = aws_ecr_repository.repository.repository_url,
#     container_name       = "${var.team}-${var.service}-dev",
#     container_port       = var.container_port,
#     host_port            = var.host_port,
#     reserved_task_memory = var.reserved_task_memory,
#     log_group            = aws_cloudwatch_log_group.dev_ecs_log_group.name,
#     environment_vars     = var.dev_ecs_environment_vars,
#     secrets              = var.dev_ecs_ssm_secrets
#   }))
#   filename = "${path.module}/templates/taskdefinition_dev_rendered.json"
# }

# data "template_file" "service_taskdefinition_dev" {
#   template = file("${path.module}/templates/taskdefinition.tpl")

#   vars = {
#     aws_region           = var.region
#     aws_account_id       = data.aws_caller_identity.current.account_id
#     environment_name     = "dev"
#     service_name         = var.service
#     image                = aws_ecr_repository.repository.repository_url
#     container_name       = "${var.team}-${var.service}-dev"
#     container_port       = var.container_port
#     host_port            = var.host_port
#     reserved_task_memory = var.reserved_task_memory
#     log_group            = aws_cloudwatch_log_group.dev_ecs_log_group.name
#     environment_vars     = var.dev_ecs_environment_vars
#     secrets              = var.dev_ecs_ssm_secrets
#   }
# }

data "template_file" "ecs_execution_role_policy_dev" {
  template = file("${path.module}/templates/ecs_execution_iam_policy.tpl")
  #TODO: refine template to user arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/${team}/${service}/{environment}* ?
  vars = {
    aws_region      = var.region
    aws_account_id  = data.aws_caller_identity.current.account_id
    service         = var.service
    team            = var.team
  }
}

data "template_file" "ecs_tasks_service_role_dev" {
  template = file("${path.module}/templates/service_assume_role.tpl")

  vars = {
    service = "ecs-tasks.amazonaws.com"
  }
}

resource "local_file" "task_definition_dev" {
    content  = templatefile("${path.module}/templates/taskdefinition.tpl", {
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
    filename = "${path.module}/files/dev-taskdefinition.json"
}