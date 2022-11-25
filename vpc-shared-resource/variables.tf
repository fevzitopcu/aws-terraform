variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "AMI" {
  type = map(any)

  default = {
    us-east-1 = "ami-0c2a1acae6667e438"
    eu-west-2 = "ami-03dea29b0216a1e03"
  }
}

variable "project" {
  description = "The name of the project"
  default     = "project"
}
variable "team-name" {
  description = "The Project Name"
  type        = string
  default     = "devops-team"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  type        = string

}
variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"

}
variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"

}
variable "availability_zones" {
  type        = list(any)
  description = "The names of the availability zones to use"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "dev"

}

variable "tenant" {
  description = "The tenant"
  type        = string
  default     = "host"

}

variable "workspace" {
  description = "The terraform workspace"
  type        = string
  default     = "default"

}