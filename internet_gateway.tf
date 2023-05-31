resource "aws_internet_gateway" "hirecoder_gateway" {
  vpc_id = aws_vpc.ecs_vpc.id
}