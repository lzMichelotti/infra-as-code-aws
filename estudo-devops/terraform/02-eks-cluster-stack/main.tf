terraform {
  backend "s3" {
    bucket       = "meu-projeto-devops-tfstate"
    key          = "eks/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.assume_role.region
  default_tags {
    tags = var.default_tags
  }
  assume_role {
    role_arn = var.assume_role.arn
  }
}