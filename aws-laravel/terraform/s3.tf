# --------------------------------------
# S3
# --------------------------------------
# random unique key
resource "random_string" "s3_unique_key" {
  length = 6
  upper = false
  lower = true
  numeric = true
  special = false
}

# s3
resource "aws_s3_bucket" "s3_static_bucket" {
  bucket = "${var.project}-bucket-${random_string.s3_unique_key.result}"

  tags = {
    Name = "tf_test_s3"
  }
}