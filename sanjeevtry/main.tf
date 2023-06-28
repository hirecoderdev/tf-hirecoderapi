resource "aws_ecs_cluster" "cluster" {
  name = "stage-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}




module "ecs-fargate" {
  source = "umotif-public/ecs-fargate/aws"
  version = "~> 6.1.0"

  name_prefix        = "ecs-fargate-hirecoder"
  vpc_id             = aws_vpc.ecs_vpc.id
  private_subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  cluster_id         = aws_ecs_cluster.cluster.id

  task_container_image   = "331689678630.dkr.ecr.us-east-1.amazonaws.com/hirecoderapi:latest"
  task_definition_cpu    = 256
  task_definition_memory = 512

  task_container_port             = 8000
  task_container_assign_public_ip = true
  load_balanced = false
  task_container_environment =var.task_container_environment_custom



  health_check = {
    port = "traffic-port"
    path = "/api/"
  }

  tags = {
    Environment = "test"
    Project = "Test"
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "backend"
  network_mode  = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "api-service"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}