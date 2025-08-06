
terraform {
  backend "s3" {
    bucket = "awsdevopsmani"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
