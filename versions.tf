terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.virginia]
    }
  }

  required_version = ">= 1.5.7"
}

# Configure the AWS Provider
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}