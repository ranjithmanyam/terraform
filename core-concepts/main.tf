provider "aws" {
    version = "~> 3.0"
    region = "eu-west-1"
}

data "aws_vpc" "vpc_data" {
    filter {
      name = "tag:Name"
      values = ["Default"]
    }
}

output "vpc_data_output" {
    value = data.aws_vpc.vpc_data
}

resource "aws_vpc" "main" {
    cidr_block = "10.1.0.0/16"
    tags = {
      "Name" = "TF-VPC"
    }
}

resource "aws_subnet" "SN-Web" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.1.0.0/24"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "TF-Subnet"
    }
}

resource "aws_instance" "webserver" {
    # count = 2
    for_each = {
        prod = "t2.micro"
        dev = "t2.micro"
    }
    ami = "ami-08f4717d06813bf00"
    # instance_type = var.my_instance_type
    instance_type = each.value
    subnet_id = aws_subnet.SN-Web.id
    
    tags = {
        # Name = "webserver0${count.index}"
        Name = "webserver ${each.key}"
    }

    provisioner "local-exec" {
        command = "echo ${self.public_ip} > public_ip.txt"
    }
}


locals {
    ingress_rules = [{
        port = 443
        description = "Port 443"
    },
    {
        port = 80
        description = "Port 80"
    }]

    egress_rules = [{
        port = 0
        description = "All Ports"
    }]
}

resource "aws_security_group" "main" {
    name = "TF-SG"
    vpc_id = data.aws_vpc.vpc_data.id

    dynamic "ingress" {
        for_each = local.ingress_rules

        content {
            description = ingress.value.description
            from_port = ingress.value.port
            to_port = ingress.value.port
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        } 
    }

    dynamic "egress" {
        for_each = local.egress_rules
        content {
            description = egress.value.description
            from_port = egress.value.port
            to_port = egress.value.port
            protocol = "-1"
            cidr_blocks = ["92.27.71.144/32"]
        } 
    }

    /*
    ingress {
        description = "Port 443"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    }

    ingress {
        description = "Port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    }
    */
    tags = {
        Name = "TF security group"
    }
}

