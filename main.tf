module "network" {
    source = "./modules/network"
}

module "database"{
    source       = "./modules/database"
    vpc_id       = module.network.vpc_id
    db_subnet_ids = module.network.db_subnet_ids
    username     = var.db_username
    password     = var.db_password
}