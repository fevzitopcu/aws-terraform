output "web-arn" {
  value = aws_instance.web.arn
}

output "web-public-ip" {
  value = aws_instance.web.public_ip
}