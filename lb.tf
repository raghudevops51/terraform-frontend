resource "aws_lb" "frontend" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-frontend-alb.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNETS
  tags = {
    Environment       = "frontend-alb"
  }
}

resource "aws_lb_listener" "frontend-http" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb" "backend" {
  name               = "backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-backend-alb.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
  tags = {
    Environment       = "frontend-alb"
  }
}

resource "aws_lb_listener" "backend-listener" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "backend-alb" {
  count               = length(var.BACKEND_COMPONENTS)
  name                = "${element(var.BACKEND_COMPONENTS, count.index)}-${var.ENV}"
  type                = "CNAME"
  zone_id             = data.terraform_remote_state.vpc.outputs.HOSTED_ZONE_ID
  ttl                 = "300"
  records             = [aws_lb.backend.dns_name]
}