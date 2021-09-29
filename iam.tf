resource "aws_iam_role" "codebuild_role" {
  name               = "${var.team}-${var.service}-codebuild-service-role"
  path               = "/service-role/"
  assume_role_policy = data.template_file.codebuild_service_role.rendered
}

resource "aws_iam_role_policy_attachment" "codebuild_role_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.team}-${var.service}-codebuild-policy"
  path        = "/"
  description = ""
  policy      = data.template_file.codebuild_policy.rendered
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.team}-${var.service}-codepipeline-service-role"
  path               = "/service-role/"
  assume_role_policy = data.template_file.codepipeline_service_role.rendered
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "${var.team}-${var.service}-codepipeline-policy"
  path        = "/"
  description = ""
  policy      = data.template_file.codepipeline_policy.rendered
}
