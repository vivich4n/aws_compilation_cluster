provider "aws" {
    profile = "your-profile"
    region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  vpc_tags = {
    Name = "cluster-vpc"
  }
}

module "ec2_farm"{
  source = "./modules/comp_farm"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  ins_type = var.ins_type
  ami = var.ami
  env = var.env
  ec2number = 2
  ec2min = 1
  ec2max = 3
  ssh_key = "main.pub"
}

module "ec2_main" {
  source = "./modules/ec2_main"
  vpc_id = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnets[0]
  ins_type = var.ins_type
  ami = var.ami
  env = var.env
  ssh_key = "main.pub"
}