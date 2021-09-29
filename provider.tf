provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
      tags = local.default_tags
  }
}
