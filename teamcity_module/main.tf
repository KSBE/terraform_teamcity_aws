data "aws_ami" "debian_stretch" {
  owners      = ["379101102735"] # debian
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "sg" {
  source = "../sg"
  vpc_id = var.vpc_id
}

module "rds" {
  source                 = "../rds"
  db_name                = var.db_name
  db_password            = var.db_password
  db_username            = var.db_username
  db_subnet_group_name   = module.vpc.db_subnet_group_name
  instance_identifier    = var.db_name
  vpc_id                 = var.vpc_id
  private_subnet_id      = [module.vpc.private_subnet]
  service_name           = "TeamCity"
  vpc_security_group_ids = module.sg.rds_security_groups_id
}

module "ec2" {
  source      = "./ec2"
  ami         = data.aws_ami.debian_stretch.image_id
  db_username = var.db_username
  db_password = var.db_password
  db_name     = var.db_name
  db_port     = module.rds.db_port
  db_url      = module.rds.database_address
  key_name    = var.key_name
  # FIXME might be worth taking this out too
  ssh_path = var.ssh_path
  # FIXME merge with security groups variable
  vpc_security_group_ids = module.sg.web_security_groups_id
}
# FIXME removed public subnet, so have to go set that in the module
