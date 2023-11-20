#create s3 bucket
resource "aws_s3_bucket" "mybucket-cicd" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "devops" {
  bucket = aws_s3_bucket.mybucket-cicd.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "devops" {
  bucket = aws_s3_bucket.mybucket-cicd.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "devops" {
  depends_on = [
    aws_s3_bucket_ownership_controls.devops,
    aws_s3_bucket_public_access_block.devops,
  ]

  bucket = aws_s3_bucket.mybucket-cicd.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket-cicd.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket-cicd.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.mybucket-cicd.id
  key = "style.css"
  source = "style.css"
  acl = "public-read"
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.mybucket-cicd.id
  key = "script.js"
  source = "script.js"
  acl = "public-read"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket-cicd.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.mybucket-cicd.id ]
}
