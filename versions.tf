terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3" # tested with v3.12.0
    }
  }
  required_version = ">= 0.13"
}
