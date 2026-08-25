resource "aws_ecs_service" "demo" {
  name            = "demo-service"
  cluster         = aws_ecs_cluster.demo.id          #Service ko banking-cluster mein run karo.
  task_definition = aws_ecs_task_definition.demo.arn #Jo container blueprint humne banaya hai, usko use karo.

  launch_type   = "FARGATE" #EC2 server manage nahi karna; AWS Fargate par container run karo.
  desired_count = 1         #Ek running task maintain karo.

  network_configuration {
    subnets = [
      aws_subnet.public.id #Task ko hamare public subnet mein run karo.
    ]

    security_groups = [
      aws_security_group.ecs_demo.id #Ye Security Group task par apply karo.
    ]

    assign_public_ip = true #Task ko public IP assign karo.
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.demo.arn
    container_name   = "demo"
    container_port   = 8008
  }

  depends_on = [
    aws_alb_listener.demo
  ]

  tags = {
    Project     = "banking-cicd"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}