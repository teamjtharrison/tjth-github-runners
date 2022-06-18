terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
}

provider "aws" {}

provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_api_key.value
}

provider "mongodbatlas" {
  public_key  = data.aws_ssm_parameter.mongodbatlas_public_key.value
  private_key = data.aws_ssm_parameter.mongodbatlas_private_key.value
}

