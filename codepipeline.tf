resource "aws_codepipeline" "pipeline" {
  name     = "${var.team}-${var.service}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = data.aws_s3_bucket.codebuild_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "checkout"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["build"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.repository.repository_name
        PollForSourceChanges = "false"
        BranchName           = "master"
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["build"]
      version          = "1"
      output_artifacts = ["imagedefinitions"]

      configuration = {
        ProjectName = aws_codebuild_project.build.id
      }
    }
  }

  stage {
    name = "Dev-Deploy"
  
    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      version          = "1"
      input_artifacts  = ["imagedefinitions"]

      configuration = {
        ClusterName = var.ecs_cluster_name_dev
        ServiceName = "${var.team}-${var.service}-dev"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}