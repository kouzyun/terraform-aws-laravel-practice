# --------------------------------------
# Route53
# --------------------------------------
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false

  tags = {
    Name    = "${var.project}-domain"
    Project = var.project
    Env     = var.environment
  }
}