terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }

  backend "s3" {
    bucket  = "gustavo-state-bucket-tf"
    region  = "sa-east-1"
    key     = "terraform.tfstate"
    encrypt = true
    profile = "gustavo"
  }

}

provider "aws" {
  profile = "gustavo"
  region  = "sa-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [
    aws_s3_bucket.terraform_state
  ]
}