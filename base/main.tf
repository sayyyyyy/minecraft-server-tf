# VPC
resource "aws_vpc" "minecraft_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "minecraft-server-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "minecraft_igw" {
  vpc_id = aws_vpc.minecraft_vpc.id

  tags = {
    Name = "minecraft-server-igw"
  }
}

# Subnet
resource "aws_subnet" "minecraft_subnet" {
  vpc_id            = aws_vpc.minecraft_vpc.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "minecraft-server-subnet"
  }
}

# Route Table
resource "aws_route_table" "minecraft_rt" {
  vpc_id = aws_vpc.minecraft_vpc.id

  tags = {
    Name = "minecraft-server-rt"
  }
}

# Route to the Internet
resource "aws_route" "minecraft_internet_route" {
  route_table_id         = aws_route_table.minecraft_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.minecraft_igw.id
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "minecraft_subnet_rt_assoc" {
  subnet_id      = aws_subnet.minecraft_subnet.id
  route_table_id = aws_route_table.minecraft_rt.id
}

# Security Group
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-server-sg"
  description = "Allow Minecraft Port"
  vpc_id      = aws_vpc.minecraft_vpc.id

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft-server-sg"
  }
}

# IAM Role for EC2
resource "aws_iam_role" "minecraft_server_iam_role" {
  name = "minecraft-server-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = {
    Name = "minecraft-server-iam-role"
  }
}