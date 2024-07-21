# --------------------------------------
# ALB Listener
# --------------------------------------
# http listener
resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      host        = aws_route53_record.route53_record.name
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}


# https listener
resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.certificte.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}