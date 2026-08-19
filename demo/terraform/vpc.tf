resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name       = "banking-cicd-vpc"
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManagedBy  = "terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true


  tags = {
    Name       = "banking-cicd-public-subnet"
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManageBy   = "terraform"
  }
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name       = "banking-cicd-igw"
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManagedBy  = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = {
    Name       = "banking-cicd-public-route-table"
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManagedBy  = "terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}