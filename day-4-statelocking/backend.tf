
terraform {
  backend "s3" {
    bucket = "awsdevopsmani"
    key    = "day-4/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true
    dynamodb_table = "mani"  #any version 
    encrypt = true
  }
}
