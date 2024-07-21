# --------------------------------------
# Security Group
# --------------------------------------
# alb security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "alb security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "alb_in_http" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_out_allow_all" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "egress"
  protocol          = "-1"
  to_port           = 0
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

#app security group
resource "aws_security_group" "app_sg" {
  name        = "${var.project}-app-sg"
  description = "app server security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "app_in_http" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "app_out_allow_all" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "-1"
  to_port           = 0
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

#db security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "db security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "db_in_3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "db_out_3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app_sg.id
}
