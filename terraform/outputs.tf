output "minecraft_public_ip" {
  description = "Public IP address of the Minecraft EC2 instance"
  value       = aws_instance.minecraft_server.public_ip
}

output "minecraft_connection" {
  description = "Minecraft server connection address"
  value       = "${aws_instance.minecraft_server.public_ip}:25565"
}