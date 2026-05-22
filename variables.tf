variable "vpc_id" {
  default = "vpc-003e2f478e6a9ca59"
}

variable "component" {
    default = {
        frontend = "t3.micro"
        # mysql = "t3.micro"
        # catalogue = "t2.micro"
        # mongodb = "t2.micro"
        # user = "t2.micro"
        # valkey = "t2.micro"
        # cart = "t2.micro"
        # shipping = "t2.micro"
        # rabbitmq = "t2.micro"
        # payment = "t2.micro"
        # orders = "t2.micro"
        # ratings = "t2.micro"
    }
}

variable "db" {
    default = {
        # mysql = "t3.micro"
        # mongodb = "t2.micro"
        # valkey = "t2.micro"
        # rabbitmq = "t2.micro"
    }
}