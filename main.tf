module "network" {
  source           = "./modules/network"
  db_subnet_1_az   = var.db_subnet_1_az
  db_subnet_2_az   = var.db_subnet_2_az
  eks_private_1_az = var.eks_private_1_az
  eks_private_2_az = var.eks_private_2_az
  eks_public_1_az  = var.eks_public_1_az
  eks_public_2_az  = var.eks_public_2_az
  cluster_name     = var.cluster_name
}

module "database" {
  source        = "./modules/database"
  vpc_id        = module.network.vpc_id
  db_subnet_ids = module.network.db_subnet_ids
  username      = var.db_username
  password      = var.db_password
}