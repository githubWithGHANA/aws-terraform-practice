#Frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "nit-dev-fe-bucket"

  tags = {
    Name = "nit-dev-fe-bucket"
  }
}

#Backend
resource "aws_s3_object" "frontend_app" {
  bucket = aws_s3_bucket.frontend_bucket.id
  key    = "app.py"
  source = "app.py"

  etag = filemd5("app.py")
}

# S3 BUCKET — Backend application jar storage
###############################################################

resource "aws_s3_bucket" "be_app_bucket" {
  bucket = "nit-dev-be-app-bucket"
  
  tags = {
    Name = "nit-dev-be-app-bucket"
  }
}
# resource "aws_s3_bucket_versioning" "be_bucket_versioning" {
#   bucket = aws_s3_bucket.be_app_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# } 

resource "aws_s3_object" "backend_app" {
  bucket = aws_s3_bucket.be_app_bucket.id
  key    = "datastore-0.0.7.jar"
  source = "datastore-0.0.7.jar"

  etag = filemd5("datastore-0.0.7.jar")
}

