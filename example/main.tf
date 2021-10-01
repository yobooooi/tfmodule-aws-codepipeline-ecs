terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.44.0"
    }
  }
  required_version = ">= 0.14.0"

  backend "s3" {
    region  = "eu-west-1"
    bucket  = "globee-terraform-state-dev"
    key     = "eu-west-1/paybee/pipelines/terraform.tfstate"
    profile = "globee"
  }
}

provider "aws" {
  profile = "globee"
  region  = "eu-west-1"
}

module "devops_project_pipeline" {

  source = "../"

  ## General Module Vars ##
  profile = "globee"
  region  = "eu-west-1"

  service       = "pipeline-module-test"
  team          = "devops"
  description   = "test the module used to create kotlin pipeline"

  ## CodeBuild Environment Vars ##
  code_build_environment_vars = {
    BUILD_TEST01 = "test01"
    BUILD_TEST02 = "test02"
    BUILD_TEST03 = "test03"
  }

  ## General ECS Vars
  container_port = "8080"
  host_port      = "32000"

  ## params for ecs DEV task ##
  dev_ecs_environment_vars = {
    TASK_ENV_01 = "test01"
    TASK_ENV_02 = "test02"
    TASK_ENV_03 = "test03"
  }

  dev_ecs_ssm_secrets = {
    SECRET_01 = "arn:aws:ssm:eu-west-1:834366213304:parameter/devops/pipeline-module-test-01"
    SECRET_02 = "arn:aws:ssm:eu-west-1:834366213304:parameter/devops/pipeline-module-test-02"
  }
}

output "repository_id" {
  value = module.devops_project_pipeline.repository_id
}

output "repository_clone_url_ssh" {
  value = module.devops_project_pipeline.repository_clone_url_ssh
}

output "codepipeline_id" {
  value = module.devops_project_pipeline.codepipeline_id
}

output "codebuild_id" {
  value = module.devops_project_pipeline.codebuild_id
}

output "ecr_repository_url" {
  value = module.devops_project_pipeline.ecr_repository_url
}

output "ecs_dev_task_definition" {
  value = module.devops_project_pipeline.ecs_dev_task_definition
}

output "ecs_dev_task_arn" {
  value =module.devops_project_pipeline.ecs_dev_task_arn
}