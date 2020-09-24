resource "null_resource" "set-aws-region" {
  provisioner "local-exec" {
    command = "export AWS_REGION=${var.aws_region}"
  }

  provisioner "local-exec" {
    command = "echo AWS_REGION"
  }
}