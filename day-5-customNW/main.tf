
# Creation of VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Creation of subnets
resource "aws_subnet" "dev_subnet1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.subnet1_cidr
  tags = {
    Name = var.subnet1_name
  }
}

resource "aws_subnet" "dev_subnet2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.subnet2_cidr
  tags = {
    Name = var.subnet2_name
  }
}

# Creation IG and attach to vpc
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.internet_gateway_name
  }
}


# Creation of route table and edit routes 
resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.dev_igw.id
  }
}

# Creation of subnet associations 
resource "aws_route_table_association" "dev_rt_assoc1" {
  subnet_id      = aws_subnet.dev_subnet1.id
  route_table_id = aws_route_table.dev_rt.id
}

# Creation of Nat Gateway
resource "aws_nat_gateway" "dev_ngw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.dev_subnet2.id
    tags = {
      Name = var.nat_gateway_name
    }
  
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


# Creation of private route table and edit routes 
resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = var.pvt_rt_cidr
    nat_gateway_id = aws_nat_gateway.dev_ngw.id
  }
}


resource "aws_route_table_association" "pvt_rt_assoc1" {
  subnet_id      = aws_subnet.dev_subnet2.id
  route_table_id = aws_route_table.pvt_rt.id
}

# Creation Security Group
resource "aws_security_group" "dev_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.security_group_name
  }

  ingress {
    description = var.http_ingress_description
    from_port   = var.http_ingress_from_port
    to_port     = var.http_ingress_to_port
    protocol    = var.http_ingress_protocol
    cidr_blocks = var.http_ingress_cidr_blocks
  }

  ingress {
    description = var.ssh_ingress_description
    from_port   = var.ssh_ingress_from_port
    to_port     = var.ssh_ingress_to_port
    protocol    = var.ssh_ingress_protocol
    cidr_blocks = var.ssh_ingress_cidr_blocks
  }

  ingress {
    description = var.https_ingress_description
    from_port   = var.https_ingress_from_port
    to_port     = var.https_ingress_to_port
    protocol    = var.https_ingress_protocol
    cidr_blocks = var.https_ingress_cidr_blocks
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }
}

# Creation of server
resource "aws_instance" "dev_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.dev_subnet1.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  tags = {
    Name = var.instance_name
  }
}


