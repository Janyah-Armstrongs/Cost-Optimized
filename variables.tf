variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment tag (dev, test, prod)"
  type        = string
  default     = "test"
}

variable "ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-00c39f71452c08778"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "budget_limit" {
  description = "Monthly budget limit for dev environment"
  type        = string
  default     = "10.00"
}

variable "notification_email" {
  description = "Email to receive budget alerts"
  type        = string
  default     = "Janyaharmstrong091406@gmail.com"  #Replace with your email
}
