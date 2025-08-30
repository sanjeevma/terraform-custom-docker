# examples/aws-infrastructure/variables.tf
variable "aws_region" {
 description = "AWS region"
 type        = string
 default     = "us-west-2"
}

variable "environment" {
 description = "Environment name"
 type        = string
 default     = "dev"
}

variable "vpc_cidr" {
 description = "CIDR block for VPC"
 type        = string
 default     = "10.0.0.0/16"
}

variable "instance_type" {
 description = "EC2 instance type"
 type        = string
 default     = "t3.micro"
}

variable "db_instance_class" {
 description = "RDS instance class"
 type        = string
 default     = "db.t3.micro"
}

variable "db_allocated_storage" {
 description = "RDS allocated storage (GB)"
 type        = number
 default     = 20
}
