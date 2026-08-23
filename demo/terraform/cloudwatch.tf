resource "aws_cloudwatch_log_group" "demo" {

  name = "/ecs/banking-cicd"

  retention_in_days = 7

  tags = {
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}