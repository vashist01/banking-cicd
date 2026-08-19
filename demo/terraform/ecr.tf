resource "aws_ecr_repository" "demo" {
  name                 = "demo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project    = "banking-cicd"
    Enviroment = "dev"
    ManagedBy  = "terraform"
  }
}