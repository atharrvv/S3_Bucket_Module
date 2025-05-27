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

# Server-side encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.encrypt ? 1 : 0

  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access 
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.block_public_access ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policies
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

# Transitioning to other storage classes
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.this.id

  # Rule 1: Your original rule for logs/ to GLACIER
  rule {
    id     = "transition-logs-to-glacier"
    status = "Enabled"

    filter {
         and {							
      prefix = ""
      object_size_greater_than = 1024
      object_size_less_than    = 104857600
 	   }
	}

    transition {
      days          = 30
      storage_class = "GLACIER" // S3 Glacier Flexible Retrieval
    }

    expiration {
      days = 365
    }
  }

  # Rule 2: Transition very old backups/ to DEEP_ARCHIVE
  rule {
    id     = "transition-backups-to-deep-archive"
    status = "Enabled"

    filter {
        and {
      prefix = ""
	    }
	}

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 1095 # Expire after 3 years
    }
  }

  # Rule 3: Transition temporary/ to STANDARD_IA and expire quickly
  rule {
    id     = "transition-temp-to-standard-ia"
    status = "Enabled"

    filter {
	 and {
      prefix = ""
	    }
	}

    transition {
      days          = 31 # Note: STANDARD_IA has a 30-day minimum charge
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 45
    }
  }

  # Rule 4: Using Intelligent-Tiering for 'smart-archive/' prefix
  rule {
    id     = "use-intelligent-tiering-for-smart-archive"
    status = "Enabled"

    filter {
      and {
      prefix = ""
      }
    }
    # Transition objects into Intelligent-Tiering after 0 days (immediately) or some other period
    transition {
      days          = 60 # Or 30, 60 etc.
      storage_class = "INTELLIGENT_TIERING"
    }
    # Expiration can still be set
    expiration {
      days = 1825 # Expire after 5 years
    }
  }
}


resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_static_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.website_index_document
  }

  error_document {
    key = var.website_error_document
  }
}


