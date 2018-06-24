resource "aws_instance" "steeleye_fe" {
  count = "1"
  ami             = "ami-6ed2fd04"
  instance_type   = "t2.micro"
  key_name = "${aws_key_pair.deployer1.key_name}"
  subnet_id = "${element(module.vpc.public_subnets,1)}"
  depends_on = ["aws_instance.steeleye_be"] 
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${module.ssh_sg.ssh_sg_id}","${module.web_sg.web_sg_id}"]
  tags {
    Name = "steeleye_fe_${count.index}"
    Terraform = "true"
    enviornment = "test"
    delete-after = "2018-10-10"
    project  = "test"
  }
  user_data = "#!/bin/bash\nrpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm\niptables -F\nyum install puppet-agent -y\n/opt/puppetlabs/bin/puppet module install puppet-nginx --version 0.12.0 "

 provisioner "local-exec" {
    command = "echo server ${aws_instance.steeleye_be.1.private_ip}':'8484';'  >> nginx/backendservers.list"
  }
provisioner "local-exec" {
    command = "echo server ${aws_instance.steeleye_be.0.private_ip}':'8484';'  >> nginx/backendservers.list"
  }

  provisioner "file" {
    source = "nginx/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]

  }


  connection {
    user = "centos"
    type = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
  }


}


resource "aws_instance" "steeleye_be" {
  count = "2"
  ami             = "ami-6ed2fd04"
  instance_type   = "t2.micro"
  key_name = "${aws_key_pair.deployer1.key_name}"
  subnet_id = "${element(module.vpc.public_subnets,1)}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${module.ssh_sg.ssh_sg_id}","${module.web_sg.web_sg_id}"]
  tags {
    Name = "be_steeleye_${count.index}"
    Terraform = "true"
    enviornment = "test"
    delete-after = "2018-10-10"
    project  = "test"
  }
  user_data = "#!/bin/bash\nrpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm\niptables -F\nyum install go -y "

provisioner "file" {
    source = "goapp/"
    destination = "/tmp/"
  }

provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/start.sh",
      "/tmp/start.sh",
    ]
  }


  connection {
    user = "centos"
    type = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
  }


}


resource "null_resource" "provision_fe_on_be_changes" {

  triggers {
    be_instance_ids = "${join(",", aws_instance.steeleye_be.*.id)}"
  }
 connection {
    user = "centos"
    type = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = "${aws_instance.steeleye_fe.public_ip}"
  }

 provisioner "local-exec" {
    command = "echo server ${aws_instance.steeleye_be.1.private_ip}':'8484';'  >> nginx/backendservers.list"
  }
provisioner "local-exec" {
    command = "echo server ${aws_instance.steeleye_be.0.private_ip}':'8484';'  >> nginx/backendservers.list"
  }

  provisioner "file" {
    source = "nginx/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }


}





resource "aws_key_pair" "deployer1" {
  key_name   = "deployer1-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
