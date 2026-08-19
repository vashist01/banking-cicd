resource "aws_security_group" "ecs_demo" { #Unauthorized traffic ko block karne ke liye.
  name        = "banking-cicd-ecs-sg"
  description = "Security group for banking demo ECS service"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "Spring Boot"
    from_port   = 8008
    to_port     = 8008
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #ECS application outbound traffic kar sakti hai.
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "banking-cicd-ecs-sg"
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManagedBy  = "terraform"
  }
}