terraform {

  cloud {
    organization = "XXXXXXX"

    workspaces {
      name = "XXXXXXX"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
  }

  required_version = ">= 1.1.0"
}