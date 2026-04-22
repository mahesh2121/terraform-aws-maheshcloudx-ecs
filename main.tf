

# Create the S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-2024" # Must be globally unique

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}
