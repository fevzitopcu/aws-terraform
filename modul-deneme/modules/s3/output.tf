output "bucket-arn" {
  value = aws_s3_bucket.b.arn
}

output "bucket-name" {
  value = aws_s3_bucket.b.id
}