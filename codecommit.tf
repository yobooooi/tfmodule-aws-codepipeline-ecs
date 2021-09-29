resource "aws_codecommit_repository" "repository" {
  repository_name = "${var.team}-${var.service}"
  description     = var.description
}