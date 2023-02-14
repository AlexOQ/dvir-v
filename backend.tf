terraform {
  required_version = "1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      env_name = var.env_name
      author   = "alexoq"
    }
  }
}
