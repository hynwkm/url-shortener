# Terraform 및 AWS 공급자 설정

# Terraform 실행 환경의 버전을 제한합니다.
terraform {
  # Terraform CLI 허용 버전: 1.6 이상, 2.0 미만.
  required_version = ">= 1.6, < 2.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# AWS 리소스를 생성할 기본 환경을 설정합니다.
provider "aws" {
  # 서울 리전에서 리소스를 생성합니다.
  region = var.region_name
}
