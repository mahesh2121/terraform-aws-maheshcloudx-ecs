output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.example.id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.example.private_ip
}

output "ec2_security_group_id" {
  description = "Security group ID for the EC2 instance"
  value       = aws_security_group.ec2_sg.id
}

output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}
