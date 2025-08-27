locals {
  region = "us-east-1"
  instance-type = "t2.micr0"
  ami = "ami-08a6efd148b1f7504"
}

provider "aws" {
  region = local.region  
}

resource "aws_instance" "name" {
  instance_type = local.instance-type
  ami = local.ami
}