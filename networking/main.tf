resource "aws_subnet" "Public_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "roboshop-pub-subnet"
  }
}

resource "aws_subnet" "Private_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "roboshop-priv-subnet"
  }
}

# resource "aws_internet_gateway" "gw" {
#   vpc_id = var.vpc_id

#   tags = {
#     Name = "roboshop-gw"
#   }
# }

resource "aws_route_table" "main_gw" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "roboshop-rt"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.main_gw.id
}


resource "aws_nat_gateway" "main" {

  subnet_id     = aws_subnet.Public_subnet.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "main_nat" {
        vpc_id = var.vpc_id

        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_nat_gateway.main.id
        }

        tags = {
            Name = "roboshop-rt"
  }
  
}

resource "aws_route_table_association" "main_nat" {
  subnet_id      = aws_subnet.Private_subnet.id
  route_table_id = aws_route_table.main_nat.id
}



