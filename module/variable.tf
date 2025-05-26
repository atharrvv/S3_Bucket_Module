variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "encrypt" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block public access to the bucket"
  type        = bool
  default     = true
}

variable "bucket_policy_statements" {
  description = "List of policy statements to apply to the S3 bucket"
  type        = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = []
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rules (transition, expiration)"
  type        = bool
  default     = true
}
