##----------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
##-----------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

##-------------------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
##-------------------------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

##-----------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
##-----------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.1"

  name        = "public-subnet"
  environment = "test"
  label_order = ["name", "environment"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

##-----------------------------------------------------
## An AWS security group acts as a virtual firewall for incoming and outgoing traffic with http-https.
##-----------------------------------------------------
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
module "ssh" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name        = "ssh"
  environment = "test"
  vpc_id      = module.vpc.vpc_id
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh traffic."
    },
  ]
  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "Allow ssh outbound traffic."
    }
  ]
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
module "http_https" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name        = "http-https"
  environment = "test"

  vpc_id = module.vpc.vpc_id
  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh traffic."
    },
    {
      rule_count  = 2
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow http traffic."
    },
    {
      rule_count  = 3
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow https traffic."
    }
  ]
  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count       = 1
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all traffic."
    }
  ]
}

##---------------------------------------------------------------------------------------------------------------------------
## AWS Identity and Access Management (IAM) roles are entities you create and assign specific permissions to that allow trusted identities such as workforce identities and applications to perform actions in AWS.
##--------------------------------------------------------------------------------------------------------------------------
module "iam-role" {
  source  = "clouddrove/iam-role/aws"
  version = "1.3.1"

  name               = "iam-role-rrr"
  environment        = "test"
  label_order        = ["name", "environment"]
  assume_role_policy = data.aws_iam_policy_document.default.json

  policy_enabled = true
  policy         = data.aws_iam_policy_document.iam-policy.json
}

##-----------------------------------------------------
## AWS Key Management Service (AWS KMS) lets you create, manage, and control cryptographic keys across your applications and AWS services.
##-----------------------------------------------------
module "kms_key" {
  source                  = "clouddrove/kms/aws"
  version                 = "1.3.1"
  name                    = "kms"
  environment             = "test"
  label_order             = ["environment", "name"]
  enabled                 = true
  description             = "KMS key for ec2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/ec22"
  policy                  = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

}

data "aws_iam_policy_document" "default" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam-policy" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
    "ssmmessages:OpenDataChannel"]
    effect    = "Allow"
    resources = ["*"]
  }
}

##-----------------------------------------------------------------------------
## ec2-pritunl module call.
##-----------------------------------------------------------------------------
module "pritunl" {
  source      = "./../"
  name        = "pritunl"
  environment = "test"

  #instance
  ami           = "ami-0a8e758f5e873d1c1"
  instance_type = "t2.medium"

  #Networking
  vpc_id            = module.vpc.vpc_id
  ssh_allowed_ip    = ["0.0.0.0/0"]
  subnet_ids        = tolist(module.public_subnets.public_subnet_id)
  ssh_allowed_ports = [22, 1194]

  #Keypair
  public_key = "k6gPQnl6+ivQ8i/jsUJ+juI7q/7vSoTpd0k9Gv7DkjGWg1527I"

  #IAM
  iam_instance_profile = module.iam-role.name

  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 20
      delete_on_termination = true
      kms_key_id            = module.kms_key.key_arn
    }
  ]

  #user data
  user_data = file("${path.module}/pritunl.sh")
}
