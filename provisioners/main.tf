provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "web" {
  ami = "ami-04137ed1a354f54c4"
  instance_type = "t2.micro"
  key_name = "aws-key"
  tags = {
    Name     = "web01"
    AutoStop = true
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/Users/ranjithmanyam/.ssh/aws-key.pem")
  }
  provisioner "file" {
    content = "foobar"
    destination = "/home/ubuntu/tutorials.txt"
  }


  provisioner "remote-exec" {
    inline = [
      "touch /home/ubuntu/remote-exec.txt",
      "echo 'Hello from tf' > /home/ubuntu/remote-exec.txt"
    ]
  }

}

module "scheduler" {
  source = "../schedular"
  aws_region = "eu-west-1"
}


output "ip" {
  value = aws_instance.web.public_ip
}
