terraform {
  backend "s3" {
    bucket         = "pneto-terraform-state-bucket"
    key            = "pneto-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pneto-project-tflock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
}
