resource "aws_lb" "api_lb" {
  name               = "api-lb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-09749969720f35b52", "subnet-0627be5b35f42fc71", "subnet-0d05fe83bb7757449"]


  enable_deletion_protection = false

}


resource "aws_lb_target_group" "api_tg5" {
  name        = "api-tg5"
  target_type = "instance"
  port        = 5000
  protocol    = "TCP"
  slow_start  = 0
  vpc_id      = "vpc-0a6720a2dbfe01300"
}

resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "5000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg5.arn
  }
}





resource "aws_lb_target_group" "api_tg3" {
  name        = "api-tg3"
  target_type = "instance"
  port        = 3000
  protocol    = "TCP"
  slow_start  = 0
  vpc_id      = "vpc-0a6720a2dbfe01300"
}

resource "aws_lb_listener" "dev" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "3000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg3.arn
  }
}
