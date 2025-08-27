provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  region = "ap-south-1"
  alias = "dev"
}
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    provider = aws.dev
    tags = {
      Name = "dev"
    }
}
resource "aws_s3_bucket" "name" {
    bucket = "awsdevopsmani"  
}
#note we can use multi provider block if diff requiremnt and diff resource and diff regions