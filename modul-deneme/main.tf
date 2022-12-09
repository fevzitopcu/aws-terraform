# module "web" {
#   source = "./modules/web"
#   count  = 2
# }

# module "s3" {
#   source = "./modules/s3"
# }

# output "web-public" {
#   value = module.web.*.web-public-ip
# }
# output "s3-bucket-arn" {
#   value = module.s3.bucket-arn
# }
#------------------------------------------------------------------------
# variable "vpc_id" {
#   default = "vpc-3e757857"
# }

# data "aws_subnet_ids" "example" {
#   vpc_id = var.vpc_id
# }

# data "aws_subnet" "example" {
#   for_each = data.aws_subnet_ids.example.ids
#   id       = each.value
# }

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.example : s.cidr_block]
# }

#---------------------------------------------
# variable "vpc_id" {
#   default = "vpc-3e757857"
# }

# data "aws_subnets" "example" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }
# }

# data "aws_subnet" "example" {
#   for_each = toset(data.aws_subnets.example.ids)
#   id       = each.value
# }

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.example : s.cidr_block]
# }

#***********************************

variable "vpc_id" {
  default = "vpc-3e757857"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-3a"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}

