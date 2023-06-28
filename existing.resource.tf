# data "aws_vpc" "stack_vpc" {
#   id = var.vpc_id
# }

# data "aws_subnets" "subnets" {
#    filter {
#      name   = "vpc-id"
#      values = [data.aws_vpc.stack_vpc.id]
#    }
# }