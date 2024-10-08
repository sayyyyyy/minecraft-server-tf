terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}

module "base" {
  source = "./base"
}

module "ec2" {
  source = "./ec2"

  subnet_id = module.base.public_subnet
  sg_id = module.base.security_group
  ssm_role = module.base.minecraft_server_iam_role
}