output "s3_bucket_arn" {
  value       = aws_s3_bucket.velero_backups.arn
  description = "The ARN of the S3 bucket"
}

output "secret" {
  value = aws_iam_access_key.velero
  sensitive = true
}