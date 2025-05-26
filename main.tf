module "my_bucket" {
  source        = "./module"
  bucket_name   = "eathervvvvvv"
  versioning    = true
  encrypt       = true
  tags          = { Environment = "Prod" }


  bucket_policy_statements = [
    {
      sid       = "AllowReadOnlyAccess"
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["arn:aws:s3:::eathervvvvvv/*"]  # ✅ Must match the bucket_name above
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::026090548018:user/dhanush"]  # ✅ Replace with your actual IAM role ARN
        }
      ]
    }
  ]

 enable_lifecycle = true 

}
