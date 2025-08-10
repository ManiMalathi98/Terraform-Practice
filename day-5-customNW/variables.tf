variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
    type = string
    default = "dev-vpc"
}

variable "subnet1_cidr" {
    type = string
    default = "10.0.0.0/24" 
}

variable "subnet1_name" {
    type = string
    default = "dev-subnet-1"
  
}

variable "subnet2_cidr" {
    type = string
    default = "10.0.1.0/24"
}
variable "subnet2_name" {
    type = string
    default = "dev-subnet-2"
  
}

variable "internet_gateway_name" {
    type = string
    default = "dev-igw"
  
}

variable "nat_gateway_name" {
    type = string
    default ="cust-ngw"
}

variable "route_table_cidr" {
    type = string
    default = "0.0.0.0/0"
  
}

variable "pvt_rt_cidr" {
    type = string
    default = "0.0.0.0/0"
  
}

variable "security_group_name" {
    type = string
    default = "dev-sg"
  
}

variable "http_ingress_from_port" {
  description = "Starting port for HTTP ingress"
  type        = number
  default     = 80
}

variable "http_ingress_to_port" {
  description = "Ending port for HTTP ingress"
  type        = number
  default     = 80
}

variable "http_ingress_protocol" {
  description = "Protocol for HTTP ingress"
  type        = string
  default     = "tcp"
}

variable "http_ingress_cidr_blocks" {
  description = "Allowed CIDR blocks for HTTP ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_ingress_description" {
  description = "Description for HTTP ingress rule"
  type        = string
  default     = "HTTP"
}

variable "ssh_ingress_description" {
  description = "Description for SSH ingress rule"
  type        = string
  default     = "SSH"
}

variable "ssh_ingress_from_port" {
  description = "Starting port for SSH ingress"
  type        = number
  default     = 22
}

variable "ssh_ingress_to_port" {
  description = "Ending port for SSH ingress"
  type        = number
  default     = 22
}

variable "ssh_ingress_protocol" {
  description = "Protocol for SSH ingress"
  type        = string
  default     = "tcp"
}

variable "ssh_ingress_cidr_blocks" {
  description = "Allowed CIDR blocks for SSH ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_ingress_description" {
  description = "Description for HTTPS ingress rule"
  type        = string
  default     = "HTTPS"
}

variable "https_ingress_from_port" {
  description = "Starting port for HTTPS ingress"
  type        = number
  default     = 443
}

variable "https_ingress_to_port" {
  description = "Ending port for HTTPS ingress"
  type        = number
  default     = 443
}

variable "https_ingress_protocol" {
  description = "Protocol for HTTPS ingress"
  type        = string
  default     = "tcp"
}

variable "https_ingress_cidr_blocks" {
  description = "Allowed CIDR blocks for HTTPS ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  description = "Starting port for egress rule"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "Ending port for egress rule"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Protocol for egress rule"
  type        = string
  default     = "-1"  # -1 means all protocols
}

variable "egress_cidr_blocks" {
  description = "Allowed CIDR blocks for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "ami_id" {
    description = "inserting the ami values to main.tf"
    type = string
    default = "ami-08a6efd148b1f7504"
  
}
variable "instance_type" {
    type = string
    default = "t2.micro"
  
}

variable "instance_name" {
    type = string
    default = "dev-server"
  
}

