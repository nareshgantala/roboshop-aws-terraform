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
  depends_on = [ module.ec2, module.dns ]
  for_each = var.component
  triggers = {
    always_run = timestamp()
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/home/ec2-user/roboshop_pem.pem")
    host = module.ec2[each.key].private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo dnf install ansible-core",
      "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-aws-ansible.git ${each.key}.yml "
     ]


  }
}
