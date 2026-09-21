variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "The CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "devops-app-cluster"
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "node_instance_type" {
  description = "The instance type for the EKS worker nodes"
  type        = string
  default     = "m7i-flex.large"
}

variable "node_min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_desired_size" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}