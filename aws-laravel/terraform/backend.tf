# --------------------------------------
# Terraform Configuration
# --------------------------------------
terraform {
  required_version = ">=1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
    bucket  = "tf-bucket-0107"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# --------------------------------------
# provider
# --------------------------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

# --------------------------------------
# provider
# --------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
}

variable "subnets_id" {
  type = map(string)
}