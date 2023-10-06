# Create a VPC

# resource <resource_type> "<resource_name>"

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  providers = {
    aws = aws.virginia
  }
  cidr = "10.0.0.0/16"
  name = "my-vpc"
  
  tags = {
    Enviorment = "prod"
  }
}