# --------------------------------------
# TargetGroup
# --------------------------------------
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.project}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id


  tags = {
    Name    = "${var.project}-app-tg"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}

# alb attachment
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.app_servers[count.index].id
}