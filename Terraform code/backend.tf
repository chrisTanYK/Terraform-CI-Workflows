# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "ecs-multi-service/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}
