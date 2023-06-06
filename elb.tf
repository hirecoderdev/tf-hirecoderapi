resource "aws_lb" "hirecoder"{
  name               = "hirecoder-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.hirecoder_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]
  #  subnet_mapping {
  #   subnet_id = aws_subnet.public_subnet_1.id
  # }
  
  idle_timeout       = 60
  enable_http2       = true
  enable_deletion_protection = true
  
  tags = {
    Environment = "dev"
  }
}
resource "aws_lb_target_group" "Hirecoder_target_group" {
  name     = "hirecoder-stage-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecs_vpc.id

  health_check {
    path = "/api/docs"
  }
}