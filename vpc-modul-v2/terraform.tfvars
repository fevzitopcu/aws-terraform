project              = "project"
aws_region           = "us-east-1"
environment          = "production"
tenant               = "host"
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_cidr             = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"] //List of Public subnet cidr range
private_subnets_cidr = ["10.0.11.0/24", "10.0.21.0/24", "10.0.31.0/24"] //List of private subnet cidr range
