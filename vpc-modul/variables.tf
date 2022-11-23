variable "region" {
  default = "us-east-1"
}

variable "service_name" {
  default = "aws-team"
}

variable "types" {
  type = map
  default = {
    us-east-1 = "t2.micro"
    us-west-1 = "t2.nano"
  }
}

