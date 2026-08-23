resource "aws_security_group" "alb" {
  name        = "banking-cicd-alb-sg"
  description = "Security group for application load balancer"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "banking-cicd-alb-sg"
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}


resource "aws_alb" "demo" {
  name               = "banking-cicd-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name        = "banking-cicd-alb"
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}


resource "aws_lb_target_group" "demo" {
  name        = "banking-cicd-demo-tg"
  port        = 8008
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demo.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/actuator/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}


resource "aws_alb_listener" "demo" {
  load_balancer_arn = aws_alb.demo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}