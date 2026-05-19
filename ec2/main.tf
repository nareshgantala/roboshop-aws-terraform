resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.size
  subnet_id     = var.instance_subnet_id

  tags = {
    Name = "${var.component}-ec2"
  }
}