resource "aws_ecs_cluster" "obtuse_orc" {
  name = var.env_name
}

resource "aws_ecs_task_definition" "wobbly_weka" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.monastic_mara.arn
  container_definitions = jsonencode([{
    name      = "${var.env_name}"
    image     = "${var.container_image}:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
  family = var.env_name
}

resource "aws_ecs_service" "kayoed_konqui" {
  name                               = var.env_name
  cluster                            = aws_ecs_cluster.obtuse_orc.id
  task_definition                    = aws_ecs_task_definition.wobbly_weka.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = [aws_security_group.ecs_task.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nimble_naiad.arn
    container_name   = var.env_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.obtuse_orc.name}/${aws_ecs_service.kayoed_konqui.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory_autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}

# output "debug" {
#   value = aws_ecs_service.kayoed_konqui
# }
