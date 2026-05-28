#!/bin/bash
set -e

sudo apt update
sudo apt upgrade -y
sudo apt install -y openjdk-21-jre-headless wget

sudo useradd -r -m -d /opt/minecraft minecraft || true
sudo mkdir -p /opt/minecraft/server
sudo chown -R minecraft:minecraft /opt/minecraft

sudo -u minecraft bash -c 'cd /opt/minecraft/server && wget -O server.jar "https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar"'

sudo -u minecraft bash -c 'cd /opt/minecraft/server && java -Xmx1G -Xms512M -jar server.jar nogui' || true

echo "eula=true" | sudo tee /opt/minecraft/server/eula.txt

sudo cp /tmp/minecraft.service /etc/systemd/system/minecraft.service

sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl restart minecraft
sudo systemctl status minecraft --no-pager