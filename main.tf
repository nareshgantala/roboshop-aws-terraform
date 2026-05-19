module "network" {
  source = "./networking"
  vpc_id = var.vpc_id
}


module "ec2" {
  for_each = var.component
  source = "./ec2"
  component = each.key
  size = each.value
  instance_subnet_id = module.network.instance_subnet_id
}

module "dns"{
    for_each = var.component
    source = "./dns"
    component = each.key
    record = module.ec2[each.key].private_ip
}


resource "null_resource" "name" {
  for_each = var.component
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "C:\\Users\\DELL\\Downloads\\roboshop_pem.pem"
    host = module.ec2[each.key].private_ip
  }
  provisioner "file" {
    source = "C:\\Users\\DELL\\Downloads\\roboshop_pem.pem"
    destination = "/home/ec2-user/roboshop_pem.pem"
  }
}
