resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.size
  subnet_id     = var.instance_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = "${var.component}-ec2"
    
  }
}