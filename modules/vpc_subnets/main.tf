resource "aws_vpc" "myvpc" {
  count = 1
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
   
  tags {
    Name = "${var.name}-${var.environment}-${count.index +1}-vpc"
    environment =  "${var.environment}"
  }

}

resource "aws_subnet" "myvpc_subnet" {
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "172.16.30.0/24"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.name}-${var.environment}-"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags {
    Name = "wordpress"
  }
}

output "myvpc_subnet_id" {
  value = "${aws_subnet.myvpc_subnet.id}"
}
