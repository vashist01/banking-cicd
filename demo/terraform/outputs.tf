output "alb_dns_name" {
  value = aws_alb.demo.dns_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.demo.repository_url
}