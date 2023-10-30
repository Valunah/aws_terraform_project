data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

data "aws_iam_policy_document" "aws_codecommit_policy" {
  statement {
    actions   = ["codecommit:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2_instance_role" {


  name               = "ec2-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  inline_policy {
    name   = "CodeCommit-Access"
    policy = data.aws_iam_policy_document.aws_codecommit_policy.json
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {


  name = "ec2-instance-role"
  role = aws_iam_role.ec2_instance_role.name
}