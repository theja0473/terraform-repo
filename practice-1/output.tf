output "instance_ip_private_addr" {
  value = aws_instance.md_first_instance.private_ip
}
output "instance_arn" {
  value = aws_instance.md_first_instance.arn
}
output "aws_instance_id" {
  value = aws_instance.md_first_instance.id
}
// output "aws_network_interface" {
//   value = aws_network_interface.md_network.id
// }
output "aws_security_group" {
  value = aws_security_group.md_security_group.id
}
output "aws_subnet" {
  value = aws_subnet.subnet.id
}
output "aws_security_default_group" {
  value = aws_security_group.default.id
}
// output "ip" {
//   value = aws_eip.ip.public_ip
// }
output "address" {
  value = "${aws_elb.web.dns_name}"
}
