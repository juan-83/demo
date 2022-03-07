terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile    = "Testing"
  access_key = "AKIAWSOUY32VIWU7HXMR"
  secret_key = "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"
}

module "my_vpc" {
  source = "../modules/vpc"
  product = "cloudvests"
  environment = "staging"
  vpc_cidr = "10.0.0.0/23"
  tenancy = "default"
  public_subnets = "10.0.0.0/25,10.0.0.128/25"
  private_subnets = "10.0.1.0/25,10.0.1.128/25"
  availability_zones = "us-east-1a,us-east-1b"

}

module "my_ec2" {
  source = "../modules/ec2"
  ami = "ami-0b0af3577fe5e3532"
  ec2_class = "t2.micro"
  key_pair = "vests"
  subnet_1a = "subnet-0d75422a8950a9ac3"
  product = "nginx"
  environment = "staging"
  vpc_id = "vpc-0f31fc416a7669c6a"

}