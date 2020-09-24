variable "my_instance_type" {
    type = string
    default = "t2.micro"
    description = "My instance type"
}

variable "instance_tags" {
    type = object({
        Name = string
        foo = number
    })
}

variable "list_type" {
    type = list(number)
}