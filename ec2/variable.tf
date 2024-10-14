variable "minecraft_server_url" {
  default = "https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar"
}

variable "java_version" {
  default = "17"
  description = "Java version"
}

variable "memory_size" {
  default = "1300M"
  description = "Server Memory Size"
}

variable "ami" {
  default = "ami-0ad215c298e692194"
  description = "EC2 Instance AMI"
}

variable "subnet_id" {}

variable "sg_id" {}

variable "ssm_role" {}