resource "aws_codebuild_project" "build" {
  name         = "${var.team}-${var.service}-build"
  description  = var.description
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type                = "CODEPIPELINE"
    artifact_identifier = "imagedefinitions.json"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    type            = "LINUX_CONTAINER"
    image           = "aws/codebuild/standard:2.0"
    privileged_mode = true

    dynamic "environment_variable" {
      for_each = var.environment_vars

      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }
  
  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/"
      stream_name = var.service
      status      = "ENABLED"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }
}
