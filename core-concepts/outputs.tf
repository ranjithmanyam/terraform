output "VPC" {
    value = aws_vpc.main
}

output "instance_ip" {
    value = aws_instance.webserver["prod"].public_ip
}

# output "instance_ip_for_loop" {
#     value = [for instance in aws_instance.webserver : instance.public_ip]
# }

output "foobar" {
    value = "foobar"
}