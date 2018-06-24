module "ssh_sg" {
        source = "./modules/ssh_sg"
        name = "allow_ssh"
        environment = "dev"
        vpc_id = "${module.vpc.vpc_id}"
        source_cidr_block = "0.0.0.0/0"
}

module "web_sg" {
        source = "./modules/web_sg"
        name = "allow_web"
        environment = "dev"
        vpc_id = "${module.vpc.vpc_id}"
        source_cidr_block = "0.0.0.0/0"
}
