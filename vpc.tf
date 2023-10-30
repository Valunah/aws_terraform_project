module "vpc_prod" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  providers = {
    aws = aws.virginia
  }
  cidr = "10.0.0.0/16"
  name = "my-vpc"

  public_inbound_acl_rules  = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
  public_outbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
  tags = {
    Environment = "prod"
  }
}

data "aws_availability_zones" "available" {
  state    = "available"
  provider = aws.virginia
}

resource "aws_subnet" "public_subnet_1a" {

  vpc_id            = module.vpc_prod.vpc_id
  availability_zone = data.aws_availability_zones.available.names[0]

  provider = aws.virginia

  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public-subnet-1a"
  }

}

resource "aws_subnet" "private_subnet_1a" {

  vpc_id            = module.vpc_prod.vpc_id
  availability_zone = data.aws_availability_zones.available.names[0]

  provider = aws.virginia

  cidr_block = "10.0.7.0/24"

  tags = {
    Name = "private-subnet-1a"
  }

}


resource "aws_internet_gateway" "igw" {
  vpc_id   = module.vpc_prod.vpc_id
  provider = aws.virginia
  tags = {
    Name = "IGW-main"
  }
}
resource "aws_route_table" "public_route" {

  vpc_id   = module.vpc_prod.vpc_id
  provider = aws.virginia
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-subnet-rt"
  }
}

resource "aws_route_table_association" "pub_subnet_rtb" {
 subnet_id      = aws_subnet.public_subnet_1a.id
 route_table_id = aws_route_table.public_route.id

  provider = aws.virginia
}
