# IAM Instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "minecraft-server-instance-profile"
  role = var.ssm_role
}

resource "aws_network_interface" "minecraft_server_network_interface" {
    subnet_id            = var.subnet_id
    security_groups      = [var.sg_id]
}

# EC2 Instance
resource "aws_instance" "minecraft_instance" {
  ami           = var.ami
  instance_type = "t4g.small"

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  network_interface {
    network_interface_id = aws_network_interface.minecraft_server_network_interface.id
    device_index         = 0
  }

  user_data = <<-EOF
    #!/bin/bash

    sudo dnf install -y java-${var.java_version}-amazon-corretto-headless
    sudo adduser minecraft
    sudo mkdir /opt/minecraft/
    sudo mkdir /opt/minecraft/server/
    cd /opt/minecraft/server

    sudo wget ${var.minecraft_server_url}

    sudo chown -R minecraft:minecraft /opt/minecraft/
    sudo java -Xmx1300M -Xms1300M -jar server.jar nogui
    sleep 40
    sed -i 's/false/true/p' eula.txt
    touch start
    printf '#!/bin/bash\njava -Xmx${var.memory_size} -Xms${var.memory_size} -jar server.jar nogui\n' | sudo tee -a start
    sudo chmod +x start
    sleep 1
    sudo touch stop
    printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")' | sudo tee -a stop
    sudo chmod +x stop
    sleep 1

    cd /etc/systemd/system/
    sudo touch minecraft.service
    printf '[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' | sudo tee -a minecraft.service
    sudo systemctl daemon-reload
    sudo systemctl enable minecraft.service
    sudo systemctl start minecraft.service
    EOF

  tags = {
    Name = "minecraft-server-instance"
  }
}