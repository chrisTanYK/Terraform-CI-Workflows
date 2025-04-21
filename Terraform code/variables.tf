variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "christanyk-ecs-cluster"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "christanyk-app-upload-bucket"
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = "christanyk-app-message-queue"
}

# VPC Configuration
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "christanyk-vpc"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet 1 Configuration
variable "public_subnet_1_cidr_block" {
  description = "The CIDR block for Public Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_1_availability_zone" {
  description = "The Availability Zone for Public Subnet 1"
  type        = string
  default     = "ap-southeast-1a"
}

# Public Subnet 2 Configuration
variable "public_subnet_2_cidr_block" {
  description = "The CIDR block for Public Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_2_availability_zone" {
  description = "The Availability Zone for Public Subnet 2"
  type        = string
  default     = "ap-southeast-1b"
}

# Security Group Configuration
variable "ecs_security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "christanyk_ecs_security_group"
}

variable "ecs_security_group_ingress_ports" {
  description = "Ports to allow inbound traffic on ECS Security Group"
  type        = list(number)
  default     = [5001, 5002]
}

# Internet Gateway Configuration
variable "igw_name" {
  description = "The name of the Internet Gateway"
  type        = string
  default     = "christanyk-igw"
}
