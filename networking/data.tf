data "aws_internet_gateway" "default" {
  filter {
    name   = "Name"
    values = ["roboshop-igw"]
  }
}