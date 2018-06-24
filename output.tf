output "ip" {
  value = "${aws_instance.steeleye_fe.public_ip}"
}
