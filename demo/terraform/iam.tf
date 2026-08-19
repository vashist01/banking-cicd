resource "aws_iam_role" "ecs_task_execution_role" { ##AWS mein IAM Role create karo.
  name = "banking-cicd-ecs-task-execution-role"     ##AWS mein actual role ka naam hoga:

  assume_role_policy = jsonencode({ ## Yahan Terraform ke andar JSON policy define kar rahe hain.
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ecs-tasks.amazonaws.com" ## ECS Tasks is role ko assume kar sakte hain. 
        ## Role create ho gaya, lekin abhi role ke paas permissions nahi hain.
      }

      Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManagedBy  = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"  

}