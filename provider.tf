terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.16.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
