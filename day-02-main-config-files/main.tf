resource "aws_instance" "dev" {
    ami = var.ami-id
    instance_type = var.instance-type
    region = "us-east-1"
    tags = {
      Name = "terraformec2"
    }
  
}