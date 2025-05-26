resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Enable versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

# Server-side encryption (SSE-S3 by default)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.encrypt ? 1 : 0

  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access (recommended)
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.block_public_access ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "this" {
  count  = length(var.bucket_policy_statements) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for statement in var.bucket_policy_statements : {
        Sid      = statement.sid
        Effect   = statement.effect
        Action   = statement.actions
        Resource = statement.resources
        Principal = {
          for principal in statement.principals :
          principal.type => principal.identifiers
        }
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-to-glacier"
    status = "Enabled"


    
     
   


    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}
