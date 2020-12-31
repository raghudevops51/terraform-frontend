data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket          = var.bucket
    key             = "vpc/${var.ENV}/terraform.tfstate"
    region          = "us-east-2"
  }
}

data "aws_ami" "nginx-ami" {
  owners            = ["973714476881"] // Change this to your account number.
  most_recent       = true
  name_regex        = "^frontend-${var.ENV}"
}
