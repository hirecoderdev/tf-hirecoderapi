resource "aws_lb" "hirecoder_fargate"{
  name               = "hirecoder-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.hirecoder_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]

  
  idle_timeout       = 60
  enable_http2       = true
  enable_deletion_protection = false
  
  tags = {
    Environment = "dev"
  }
  
}

resource "aws_lb_target_group" "hirecoder_fargate" {
  name        = "tg-fargate-hirecoder"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  
  target_type = "ip"

  health_check {
    path = "/api/"
    timeout = 60
    interval = 120
  }
}


resource "aws_lb_listener" "hirecoder_fargate" {
  load_balancer_arn = aws_lb.hirecoder_fargate.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hirecoder_fargate.arn
  }
}