terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# AWS infrastructure manage karne ke liye AWS provider use karo.
provider "aws" {
  region  = "ap-south-1"
  profile = "banking-dev"
}