
# 📦 AWS S3 Bucket Terraform Module

This Terraform module provisions a secure, configurable AWS S3 bucket. It emphasizes best practices in Infrastructure as Code (IaC), enabling reusable, scalable, and maintainable cloud infrastructure.

---

## 🚀 Features

- Automated creation of an S3 bucket with customizable settings
- Configurable Access Control List (ACL)
- Optional bucket versioning to protect against accidental deletion or overwrite
- Server-side encryption for data security
- Support for tagging buckets for resource management and cost tracking

---

## 🧱 Module Structure

```
module/
├── main.tf          # Core resource definitions
├── variables.tf     # Input variable declarations
├── outputs.tf       # Output values
```

---

## 🔧 Usage Example

```hcl
module "s3_bucket" {
  source      = "./module"

  bucket_name = "my-unique-bucket-name"
  acl         = "private"
  versioning  = true

  tags = {
    Environment = "Dev"
    Project     = "S3Module"
  }
}
```

---

## 📥 Inputs

| Name        | Description                     | Type             | Default   | Required |
|-------------|---------------------------------|------------------|-----------|:--------:|
| bucket_name | Name of the S3 bucket            | string           | n/a       | yes      |
| acl         | Canned ACL to apply              | string           | "private" | no       |
| versioning  | Enable versioning                | bool             | false     | no       |
| tags        | Map of tags to assign to bucket | map(string)      | `{}`      | no       |

---

## 📤 Outputs

| Name              | Description                 |
|-------------------|-----------------------------|
| bucket_id         | The name of the created bucket |
| bucket_arn        | ARN of the created bucket   |
| bucket_domain_name | The bucket's domain name    |

---

## ✅ Best Practices

- **Use Variables:** Customize your buckets through input variables to keep your module reusable.
- **Version Control:** Manage Terraform configurations using Git for collaboration and change tracking.
- **Remote State:** Store Terraform state remotely for team collaboration and state locking.
- **Secure Credentials:** Use IAM roles and policies to restrict access to your S3 bucket.

---

## 🤝 Connect with Me

- GitHub: [@atharrvv](https://github.com/atharrvv)

---

Feel free to reach out if you have any questions or need assistance!
