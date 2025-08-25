provider "aws" {
  region = "us-east-1"
}
#KeyPair
resource "aws_key_pair" "example" {
    key_name = "custom"
    public_key = file("~/.ssh/id_ed25519.pub")
}
#creation of vpc
resource "aws_vpc" "cust_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "cust_vpc"
    }
}
#creation of subnet
resource "aws_subnet" "cust_subnet1" {
  vpc_id = aws_vpc.cust_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}
#creation of IGW and attach to VPC
resource "aws_internet_gateway" "cust_igw" {
  vpc_id = aws_vpc.cust_vpc.id
  tags = {
    Name = "cust-igw"
  }
}
#creation of Route table and edit routes
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.cust_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cust_igw.id
   }
  tags = {
    Name = "Public-Route-Table"
  }
}
#edit route table association
resource "aws_route_table_association" "cust_rt_assoc1" {
    subnet_id         = aws_subnet.cust_subnet1.id
    route_table_id    = aws_route_table.pub_rt.id 
}
#creation of Security Group
resource "aws_security_group" "cust_sg" {
    description = "allow"
    vpc_id = aws_vpc.cust_vpc.id
    tags = {
      Name = "cust-sg"
    }
    ingress {
        description = "allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        description = "allow SSH"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#creation of server(Ubuntu)
resource "aws_instance" "cust" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.cust_subnet1.id
    vpc_security_group_ids = [aws_security_group.cust_sg.id]
    associate_public_ip_address = true
    key_name = aws_key_pair.example.key_name
    tags = {
      Name = "cust"
    }
}
#  connection {
#      type        = "ssh"
#      user        = "ubuntu"                          # ✅ Correct for Ubuntu AMIs
#      private_key = file("~/.ssh/id_ed25519")             # Path to private key
#      host        = self.public_ip
#      timeout     = "2m"
#   }
  
#   provisioner "file" {
#     source      = "file10"
#     destination = "/home/ubuntu/file10"
#   }

#   provisioner "remote-exec" {  #server inside 
#     inline = [
#       "touch /home/ubuntu/file200",
#       "echo 'hello from devops' >> /home/ubuntu/file200"
#     ]
#   }
#    provisioner "local-exec" {  # where terraform is runnig inside the directory 
#     command = "touch file500" 
   
#  }

resource "null_resource" "run_script" {
    provisioner "remote-exec" {
     connection {
       host = aws_instance.cust.public_ip
       user = "ubuntu"
       private_key = file("~/.ssh/id_ed25519")
       timeout     = "60s"
     } 
     inline = [ 
        "echo 'Hello from Devops' >> /home/ubuntu/file200"
      ]
    }
    triggers = {
      always_run = "${timestamp()}" #Forces rerun every time
    }
}


#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply