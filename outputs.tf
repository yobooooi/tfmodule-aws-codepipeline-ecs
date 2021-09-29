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