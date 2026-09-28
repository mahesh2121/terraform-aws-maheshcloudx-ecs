
# Get current AWS account ID for unique naming
data "aws_caller_identity" "current" {}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create S3 Bucket with dynamically unique name
resource "aws_s3_bucket" "example" {
  bucket = "${var.project_name}-bucket-${data.aws_caller_identity.current.account_id}-${var.environment}"

  tags = {
    Name        = "${var.project_name} Bucket"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

# Create Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg-${var.environment}"
  description = "Security group for ${var.project_name} EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  # Allow inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
  }

  # Allow inbound HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ec2-sg"
    Environment = var.environment
  }
}

# Create one EC2 instance
resource "aws_instance" "example" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.enable_public_ip

  tags = {
    Name        = "${var.project_name}-ec2-instance"
    Environment = var.environment
    Project     = var.project_name
  }
}
