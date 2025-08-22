
module "dev" {
  source = "../day-7-modules-source"
  ami-id = "ami-08a6efd148b1f75045"
  instance-type = "t2.micro"
  name = "test"
}
