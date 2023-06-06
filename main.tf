resource "aws_ecs_cluster" "cluster" {
  name = "hirecoder-ecs-cluster"

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

module "ecs-fargate" {
  source  = "umotif-public/ecs-fargate/aws"
  version = "~> 6.1.0"

  name_prefix        = "ecs-fargate-hirecoder"
  vpc_id             = aws_vpc.ecs_vpc.id
  private_subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  cluster_id = aws_ecs_cluster.cluster.id

  # task_container_image   = "mayukh001/flaskapp:latest"
  task_container_image   = "331689678630.dkr.ecr.us-east-1.amazonaws.com/hirecoderapi:latest"
  task_definition_cpu    = 2048
  task_definition_memory = 4096

  task_container_port             = 5000
  task_container_assign_public_ip = true

  load_balanced = false

  target_groups = [
    {
      target_group_name = "tg-fargate-hirecoder"
      container_port    = 80
    }
  ]

  health_check = {
    port = "traffic-port"
    path = "/api/docs"
  }

  tags = {
    Environment = "dev"
    Project     = "Dev"
  }
}

