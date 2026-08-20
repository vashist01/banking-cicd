resource "aws_ecs_cluster" "demo" { # AWS mein ECS Cluster create karo.
  name = "banking-cluster"

  tags = {
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}