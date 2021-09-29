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

#TODO: add java runtime parameter
data "template_file" "buildspec" {
  template = file("${path.module}/templates/buildspec.tpl")

  vars = {
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