module "internet_facing_sg" {

  source = "terraform-aws-modules/security-group/aws"

  name        = "public-sg"
  description = "Security group for internet facing EC2s within the VPC"
  vpc_id      = module.vpc_prod.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP Access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS Access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH Access"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      description = "Internet Access"
    }
  ]
}


data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]

  }
}
module "ec2_instance" {


  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "instance_devops"

  instance_type          = "t3a.micro"
  ami                    = data.aws_ami.amazon_linux_2.id
  key_name               = "ec2-key"
  vpc_security_group_ids = [module.internet_facing_sg.security_group_id]
  subnet_id              = aws_subnet.public_subnet_1a.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  create_spot_instance = true
  spot_price           = "0.30"
  spot_type            = "persistent"

  associate_public_ip_address = true
  
  user_data_base64  = base64encode(var.user_data)
  root_block_device = [ 
    {
      volume_type = "gp3"
      volume_size = 8
    }
   ]
}