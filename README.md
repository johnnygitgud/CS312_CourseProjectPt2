# Minecraft Server Automation on AWS EC2

## Background

Automate the deployment of Minecraft Java Edition server on AWS EC2. The infrastructure is created with Terraform. The server configuration uses a Bash script and a systemd service.

The goal is to setup an EC2 instance, configure networking, install Minecraft, and make sure the server automatically restarts after the instance reboots.

## Requirements

Install these tools before running the project:

- Git v2.54.0
- Terraform v1.15.5
- AWS CLI v2.34.55
- Nmap v7.80
- Git Bash


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

## References

[1] HashiCorp, “Provision an EC2 Instance on AWS,” Terraform Tutorials. [Online]. Available: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-create. [Accessed: 28-May-2026].

[2] HashiCorp, “Terraform AWS Provider Documentation.” [Online]. Available: https://registry.terraform.io/providers/hashicorp/aws/latest/docs. [Accessed: 28-May-2026].

[3] Amazon Web Services, “AWS Command Line Interface Documentation.” [Online]. Available: https://docs.aws.amazon.com/cli/. [Accessed: 28-May-2026].

[4] Amazon Web Services, “Amazon EC2 Documentation.” [Online]. Available: https://docs.aws.amazon.com/ec2/. [Accessed: 28-May-2026].

[5] Mojang Studios, “Minecraft: Java Edition Server Download.” [Online]. Available: https://www.minecraft.net/en-us/download/server. [Accessed: 28-May-2026].

[6] Canonical Ltd., “Ubuntu Server Documentation.” [Online]. Available: https://ubuntu.com/server/docs. [Accessed: 28-May-2026].

[7] Suse, “systemd Documentation.” [Online]. Available:https://documentation.suse.com/smart/systems-management/html/systemd-basics/index.html. [Accessed: 28-May-2026].

[8] Gordon Lyon, “Nmap Reference Guide.” [Online]. Available: https://nmap.org/docs.html. [Accessed: 28-May-2026].
