# Minecraft Server Automation on AWS EC2

## Background

This project automates the deployment of a Minecraft Java Edition server on AWS EC2. The infrastructure is created with Terraform, while the server configuration is handled with a Bash script and a systemd service.

The goal is to provision an EC2 instance, configure networking, install Minecraft, and make sure the server automatically restarts after the instance reboots.

## Requirements

Install these tools before running the project:

- Git
- Terraform
- AWS CLI
- Nmap
- An AWS Academy Learner Lab account
- An existing AWS EC2 key pair

AWS CLI must be configured with temporary AWS Academy credentials.

## Pipeline Overview

```text
Configure AWS CLI credentials
        ↓
Run Terraform
        ↓
Create EC2 instance and security group
        ↓
Copy Minecraft setup files to EC2
        ↓
Run setup script
        ↓
Start Minecraft with systemd
        ↓
Verify connection with nmap
```

## Project Structure

```text
terraform/
  main.tf
  variables.tf
  outputs.tf
  terraform.tfvars

scripts/
  install_minecraft.sh
  minecraft.service

README.md
```

## Terraform Setup

Go into the Terraform folder:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Preview the infrastructure:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

Print the Minecraft server public IP:

```bash
terraform output
```

## Server Configuration

Copy the Minecraft service file to the EC2 instance:

```bash
scp -i ~/YourPathToTheKey scripts/minecraft.service ubuntu@INSTANCE_PUBLIC_IP:/tmp/minecraft.service
```

Copy the install script:

```bash
scp -i ~/YourPathToTheKey scripts/install_minecraft.sh ubuntu@INSTANCE_PUBLIC_IP:/tmp/install_minecraft.sh
```

Run the install script remotely:

```bash
ssh -i ~/YourPathToTheKey ubuntu@INSTANCE_PUBLIC_IP "chmod +x /tmp/install_minecraft.sh && /tmp/install_minecraft.sh"
```

Replace `INSTANCE_PUBLIC_IP` with the public IP printed by Terraform.

## Verify the Server

Check that the Minecraft service is running:

```bash
ssh -i ~/YourPathToTheKey ubuntu@INSTANCE_PUBLIC_IP "sudo systemctl status minecraft --no-pager"
```

Check that port `25565` is listening:

```bash
ssh -i ~/YourPathToTheKey ubuntu@INSTANCE_PUBLIC_IP "sudo ss -tulpn | grep 25565"
```

Run the required nmap scan:

```bash
nmap -sV -Pn -p T:25565 INSTANCE_PUBLIC_IP
```

A successful result should show port `25565/tcp` as open and identify the service as Minecraft.

## Auto-Restart Test

Reboot the EC2 instance:

```bash
ssh -i ~/YourPathToTheKey ubuntu@INSTANCE_PUBLIC_IP "sudo reboot"
```

After the instance comes back online, check the service again:

```bash
ssh -i ~/YourPathToTheKey ubuntu@INSTANCE_PUBLIC_IP "sudo systemctl status minecraft --no-pager"
```

If the service is active and port `25565` is listening, then the Minecraft server successfully restarted after reboot.

## Connecting to the Server

Use the Minecraft Java Edition client and connect to:

```text
INSTANCE_PUBLIC_IP:25565
```

## Sources

- Terraform AWS Provider Documentation
- AWS CLI Documentation
- Minecraft Server Download Page
- Nmap Documentation
- Ubuntu systemd Documentation