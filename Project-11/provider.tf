terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.50"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Availability Zones
data "aws_availability_zones" "available" {}