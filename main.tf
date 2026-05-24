module "network" {
  source = "./networking"
  vpc_id = var.vpc_id
}


module "ec2_ui" {
  for_each = var.ui
  source = "./ec2"
  component = each.key
  size = each.value
  instance_subnet_id = module.network.instance_subnet_id
}

module "dns_ui"{
    for_each = var.ui
    source = "./dns"
    component = each.key
    record = module.ec2_ui[each.key].private_ip
}


module "ec2_app" {
  for_each = var.app
  source = "./ec2"
  component = each.key
  size = each.value
  instance_subnet_id = module.network.instance_subnet_id
}

module "dns_app"{
    for_each = var.app
    source = "./dns"
    component = each.key
    record = module.ec2_app[each.key].private_ip
}

module "ec2_db" {
  for_each = var.db
  source = "./ec2"
  component = each.key
  size = each.value
  instance_subnet_id = module.network.instance_subnet_id
}

module "dns_db"{
    for_each = var.db
    source = "./dns"
    component = each.key
    record = module.ec2_db[each.key].private_ip
}


resource "null_resource" "db_ansible" {
  depends_on = [ module.ec2_db, module.dns_db ]
  for_each = var.db
  triggers = {
    always_run = timestamp()
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/home/ec2-user/roboshop_pem.pem")
    host = module.ec2_db[each.key].private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo dnf install ansible-core -y",
      "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-aws-ansible.git ${each.key}.yml "
     ]


  }
}


resource "null_resource" "app_ansible" {
  depends_on = [ module.ec2_app, module.dns_app, null_resource.db_ansible ]
  for_each = var.app
  triggers = {
    always_run = timestamp()
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/home/ec2-user/roboshop_pem.pem")
    host = module.ec2_app[each.key].private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo dnf install ansible-core -y",
      "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-aws-ansible.git ${each.key}.yml "
     ]


  }
}


resource "null_resource" "ui_ansible" {
  depends_on = [ module.ec2_ui, module.dns_ui, null_resource.app_ansible, null_resource.db_ansible  ]
  for_each = var.app
  triggers = {
    always_run = timestamp()
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/home/ec2-user/roboshop_pem.pem")
    host = module.ec2_app[each.key].private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo dnf install ansible-core -y",
      "ansible-pull -i localhost, -U https://github.com/nareshgantala/roboshop-aws-ansible.git ${each.key}.yml "
     ]


  }
}

