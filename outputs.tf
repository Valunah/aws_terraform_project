output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "private_key" {
  value     = tls_private_key.ec2_keypair.private_key_pem
  sensitive = true
}

output "public_key" {
  value     = tls_private_key.ec2_keypair.public_key_pem
  sensitive = true
}