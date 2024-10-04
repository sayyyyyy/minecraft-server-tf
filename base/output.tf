# Outputs
output "public_subnet" {
  description = "Public Subnet"
  value       = aws_subnet.minecraft_subnet.id
}

output "security_group" {
  description = "EC2 Security Group"
  value       = aws_security_group.minecraft_sg.id
}

output "minecraft_server_iam_role" {
  description = "Minecraft Server IAM Role"
  value       = aws_iam_role.minecraft_server_iam_role.id
}