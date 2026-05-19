resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.size
  subnet_id     = var.instance_subnet.id

  tags = {
    Name = "${var.component}-ec2"
  }
}