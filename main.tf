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

# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}
