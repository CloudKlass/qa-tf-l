terraform {

  cloud {
    organization = "TestOrg-QATIP" # Ensure this matches the Org created in the browser

    workspaces {
      name = "lab6-workspace" # use a unique name within your organisation
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }

  required_version = ">= 1.1.0"
}

