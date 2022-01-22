# ---------------------------
# Terraform Configure
# ---------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# ---------------------------
# Provider
# ---------------------------
provider "aws" {
  profile = "teraform_user"
  region  = "ap-northeast-1"
}

# ---------------------------
# Variables
# ---------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}
