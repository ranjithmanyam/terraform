resource "aws_subnet" "webserver" {
  cidr_block = var.cidr_block
  vpc_id = var.vpc_id
}

resource "aws_instance" "webserver" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.webserver.id

  tags = {
    Name = "${var.webserver_name} webserver"
  }
}