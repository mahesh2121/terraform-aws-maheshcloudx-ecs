variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "maheshcloudx"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "enable_public_ip" {
  description = "Assign public IP to EC2 instance"
  type        = bool
  default     = true
}
