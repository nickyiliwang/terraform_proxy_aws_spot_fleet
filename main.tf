module "networking" {
  source          = "./networking"
  vpc_cidr        = local.vpc_cidr
  access_ip       = var.access_ip
  security_groups = local.security_groups
  public_sn_count = 1
  // 200 aws hard limit
  max_subnets = 20
  // even nums for public, max 255 to have enough subnets
  public_cidrs = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

module "compute" {
  source         = "./compute"
  instance_count = 1
  instance_type  = "t2.micro"
  public_sg      = module.networking.public_sg_out
  public_subnets = module.networking.public_subnets
  vol_size       = 8

  key_name = "A4L"
}
