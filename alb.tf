resource "aws_lb" "wily_woodpeck" {
  name               = var.env_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "nimble_naiad" {
  name        = var.env_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.occult_orca.id
  target_type = "ip"
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.wily_woodpeck.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nimble_naiad.id
    type             = "forward"
  }
}
