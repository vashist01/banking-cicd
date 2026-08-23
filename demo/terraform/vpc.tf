#Application ko kis network mein run karna hai, Internet se kaise baat karegi, aur kaunsa traffic allow karna hai?

#Isi problem ko solve karne ke liye VPC, Subnet, Internet Gateway, Route Table aur Security Group use hote hain.

resource "aws_vpc" "demo" {  #AWS mein VPC create karo. AWS resource type hai. demo  kya kyoun hota VPC provides an isolated virtual network in AWS where our application resources can communicate securely.
  cidr_block = "10.0.0.0/16" # Ye VPC ka IP address range define karta hai.  
  #Iske andar hum subnet bana sakte hain: 10.0.1.0/24 10.0.2.0/24 10.0.3.0/24
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name        = "banking-cicd-vpc"
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "public" { #VPC bahut bada network hai. Uske andar smaller networks banate hain — Subnets.
  #Kyun use hota hai? Resources ko specific network area mein place karne ke liye.
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true


  tags = {
    Name = "banking-cicd-public-subnet" #internet connectivity possible.
    #Private subnet: Direct Internet exposure nahi.
    Project     = "banking-cicd"
    Environment = "dev"
    ManageBy    = "terraform"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "banking-cicd-public-subnet-2"
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}


resource "aws_internet_gateway" "demo" {
  #VPC apne aap Internet se connected nahi hota. Internet Gateway ek entry/exit point provide karta hai.
  vpc_id = aws_vpc.demo.id

  tags = {
    Name        = "banking-cicd-igw"
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table" "public" { #Traffic routing decide karne ke liye "Mujhe Internet par kisi server se communicate karna hai."
  vpc_id = aws_vpc.demo.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = {
    Name        = "banking-cicd-public-route-table"
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table_association" "public" { #Route table ko particular subnet se connect karne ke liye.
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}