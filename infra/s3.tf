resource "aws_s3_bucket" "skkuding-s3" {
  bucket = "skkuding-dh-s3-tf"
  #Access Control List -> 사장될 예정
  #acl = "private"
}

resource "aws_s3_bucket_public_access_block" "s3-public-access" {
  bucket = aws_s3_bucket.skkuding-s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

/*
variable "files" {
    type = list(string)
    default = ["index.html", "script.js", "style.css"]
}
*/

#https://developer.hashicorp.com/terraform/language/functions/fileset


resource "aws_s3_object" "files" {
  #for_each = toset(var.files)
  for_each = { for f in fileset("${path.module}/contents", "*") : f => f if contains(["html", "css", "js"], split(".", f)[1]) }
  bucket   = aws_s3_bucket.skkuding-s3.id
  key      = each.value
  source   = "${path.module}/contents/${each.value}"
  etag     = filemd5("${path.module}/contents/${each.value}")

  #count = contains(["html", "css", "js"], split(".", each.value)[1]) ? 1 : 0

  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
  }, split(".", each.value)[1], "null")
}

resource "aws_s3_bucket_policy" "s3-bucket-policy" {
  bucket = aws_s3_bucket.skkuding-s3.id
  policy = <<EOT
    {
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
			"Sid": "PublicReadGetObject",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "${aws_s3_bucket.skkuding-s3.arn}/*"
		}
        ]
    }
    EOT

  depends_on = [aws_s3_bucket_public_access_block.s3-public-access]
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.skkuding-s3.bucket_regional_domain_name
}


resource "aws_s3_bucket_website_configuration" "static-web-hosting" {
  bucket = aws_s3_bucket.skkuding-s3.id
  index_document {
    suffix = "index.html"
  }
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static-web-hosting.website_endpoint
}