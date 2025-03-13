# # EC2 outputs
# output "instance_public_ip_addr" {
#   description = "Public IP address of ec2 instance"
#   value       = aws_instance.employee-web-app.public_ip
# }

output "load-balancer-dns-name" {
	description = "Load balancer DNS name"
	value = aws_lb.app.dns_name
}