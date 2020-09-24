provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "mykey" {
  key_name = "defaultKey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "webserver" {
  ami = "ami-0019f18ee3d4157d3"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mykey.key_name

  tags = {
    Name = "Webserver"
    Test = "Testing connection"
  }
  connection {
    type = "ssh"
    user = "centos"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo abc > test.txt"
    ]
  }
}