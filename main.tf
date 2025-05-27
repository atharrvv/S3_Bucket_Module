module "my_bucket" {
  source        = "./module"
  bucket_name   = "eathervvvvvv"
  versioning    = true
  encrypt       = true
  tags          = { Environment = "Prod" }


 # bucket_policy_statements = [
 #   {
 #     sid       = "PublicReadGetObject"
 #     effect    = "Allow"
 #     actions   = ["s3:GetObject"]

 #     resources = ["arn:aws:s3:::eathervvvvvv/*"]
 #     principals = [
 #       {
 #         type        = "AWS"
 #         identifiers = ["arn:aws:iam::026090548018:user/dhanush"]  
 #       }
 #     ]
 #   }
 # ]

 enable_lifecycle = true 
 enable_static_website  = true
 website_index_document = "home.html"
 website_error_document = "404.html"

}
