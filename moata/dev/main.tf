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
  environment = "dev"
  vpc_cidr = "10.0.0.0/23"
  tenancy = "default"
  public_subnets = "10.0.0.0/25,10.0.0.128/25"
  private_subnets = "10.0.1.0/25,10.0.1.128/25"
  availability_zones = "us-east-1a,us-east-1b"

}

module "my_ec2" {
  source = "../modules/ec2"
  ami = "ami-0b0ea68c435eb488d"
  ec2_class = "t2.micro"
  key_pair = "vests"
  subnet_1a = "subnet-0d75422a8950a9ac3"
  product = "nginx"
  environment = "dev"
  vpc_id = "vpc-0f31fc416a7669c6a"

  # nginx installation
  # storing the nginx.sh file in the EC2 instnace
  provisioner "file" {
    source      = "nginx.sh"
    destination = "/tmp/nginx.sh"
  }
  # Exicuting the nginx.sh file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }# Setting up the ssh connection to install the nginx server
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }





}