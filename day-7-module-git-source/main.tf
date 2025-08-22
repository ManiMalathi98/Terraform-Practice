module "prod" {
    source = "github.com/ManiMalathi98/Terraform-Practice/day-7-modules-source"
    ami-id = "ami-08a6efd148b1f7504"
    instance-type = "t2.micro"
    name = "test"
  
}