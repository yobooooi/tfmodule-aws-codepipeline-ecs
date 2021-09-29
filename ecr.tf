resource "aws_ecr_repository" "repository" {
  name = "${var.team}-${var.service}"
}