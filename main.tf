module "network" {
  source = "./networking"
  vpc_id = var.vpc_id
}


module "ec2" {
  for_each = var.component
  source = "./ec2"
  component = each.key
  size = each.value
  instance_subnet.id = module.network.instance_subnet.id
}
