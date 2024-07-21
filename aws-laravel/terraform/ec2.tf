# --------------------------------------
# Key Pair
# --------------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-keypair"
  public_key = file("./src/menta-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------------
# EIP
# --------------------------------------
resource "aws_eip" "eip" {
  count    = 2
  instance = element(aws_instance.app_servers.*.id, count.index % 2)
  domain   = "vpc"
}

# --------------------------------------
# EC2 Instance
# --------------------------------------
resource "aws_instance" "app_servers" {
  count                       = 2
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = lookup(var.subnets_id, count.index % 2)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = aws_key_pair.keypair.key_name
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name    = "${var.project}-app-ec2-${count.index + 1}"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}