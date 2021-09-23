
# Creates the S3 to store the backups
resource "aws_s3_bucket" "velero_backups" {
  bucket = "velero-backup-demo-eks1347"
  # Enable versioning so we can see the full revision history of our 
  # state files

  versioning {
    enabled = true
  }

  # Enable server-side encryption by default

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
