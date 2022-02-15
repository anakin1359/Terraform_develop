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
  backend "s3" {
    bucket  = "tastylog-tfstat-bucket-anakin1359" # S3バケットに設定した名称を指定
    key     = "tastylog-dev.tfstate"              # 開発環境用のxxx.tfstate（任意の名称を設定）
    region  = "ap-northeast-1"                    # S3バケットを作成したリージョンを指定
    profile = "teraform_user"                     # profileで設定しているユーザを指定(cat ~/.aws/configで確認)
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
