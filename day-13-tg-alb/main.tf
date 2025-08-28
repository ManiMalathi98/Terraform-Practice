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
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "cust_subnet2" {
  vpc_id = aws_vpc.cust_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
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
#edit subnet association
resource "aws_route_table_association" "cust_rt_assoc1" {
    subnet_id         = aws_subnet.cust_subnet1.id
    route_table_id    = aws_route_table.pub_rt.id 
}
resource "aws_route_table_association" "cust_rt_assoc2" {
    subnet_id         = aws_subnet.cust_subnet2.id
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
#Creation of Server
resource "aws_instance" "test_1" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    subnet_id              = aws_subnet.cust_subnet1.id 
    vpc_security_group_ids = [aws_security_group.cust_sg.id]
    key_name               = aws_key_pair.example.key_name

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl enable httpd
                sudo systemctl start httpd
                echo "<h1>Hello from Test-1</h1>" > /var/www/html/index.html
                EOF


    tags = {
      Name = "test-1"
    }
}
resource "aws_instance" "test_2" {
    ami                    = "ami-08a6efd148b1f7504"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.cust_subnet2.id  # Or assign based on index if needed
    vpc_security_group_ids = [aws_security_group.cust_sg.id]
    key_name               = aws_key_pair.example.key_name

user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl enable httpd
                sudo systemctl start httpd
                echo "<h1>Hello from Test-2</h1>" > /var/www/html/index.html
                EOF
    tags = {
      Name = "test-2"
    }
}


#Creation of Load Balancer and Target Group
resource "aws_lb" "cust_alb" {
  name      = "cust-alb"
  internal  = false
  load_balancer_type = "application"
  subnets = [aws_subnet.cust_subnet1.id,aws_subnet.cust_subnet2.id]
  security_groups = [aws_security_group.cust_sg.id]

} 
resource "aws_lb_target_group" "cust_tg" {
    name = "cust-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.cust_vpc.id

    health_check {
      path = "/"
    }
}
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.cust_tg.arn
  target_id = aws_instance.test_1.id
  port = 80
}
resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.cust_tg.arn
  target_id = aws_instance.test_2.id
  port = 80
}
resource "aws_lb_listener" "cust_listener" {
  load_balancer_arn = aws_lb.cust_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.cust_tg.arn
  }   
}

# output "instance_public_ips" {
#   value = {
#     test_1 = aws_instance.test_1.public_ip
#     test_2 = aws_instance.test_2.public_ip
#   }
# }

output "alb_dns_name" {
  value = aws_lb.cust_alb.dns_name
}

