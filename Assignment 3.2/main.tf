provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "christanyk-sctp-demo-tfstate"
    key    = "terraform-ci.tfstate"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${split("/", data.aws_caller_identity.current.arn)[1]}"
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "christanyk-ci_demo_bucket" {
  bucket = "${local.name_prefix}-ci-demo-${local.account_id}"
}
