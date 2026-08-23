resource "aws_ecs_task_definition" "demo" {
  family                   = "demo"
  requires_compatibilities = ["FARGATE"] # Matlab:ECS task Fargate par chalega.
  # hume EC2 server manage nahi karna padega.

  network_mode = "awsvpc" #Fargate ke liye important hai. Task ko apna network interface/IP milta hai.


  cpu    = "256" #Initial demo ke liye small allocation.
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn #Terraform automatically dependency samajh lega:
  #Yani IAM role pehle create hoga.

  container_definitions = jsonencode([
    {
      name  = "demo"
      image = "${aws_ecr_repository.demo.repository_url}:${var.image_tag}"
      #Terraform ECR repository ka URL automatically use karega.Lekin production mein latest ideal nahi hai
      #demo:${GIT_COMMIT_SHA} because immutable version tracking/rollback easy hota hai.


      essential = true
      portMappings = [{

        containerPort = 8008 #par chalti hai,
        protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}