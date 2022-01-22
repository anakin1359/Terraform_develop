# ---------------------------
# Terraform Configure
# ---------------------------
terraform {
  required_version = ">=0.13" # 0.13以上のバージョンを指定
  required_providers {
    aws = {
      source  = "hashicorp/aws" # モジュール名を指定
      version = "~>3.0"         # 3.0以上（マイナーバージョンは無視する）
    }
  }
}

# ---------------------------
# Provider
# ---------------------------
provider "aws" {
  profile = "terraform"
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
