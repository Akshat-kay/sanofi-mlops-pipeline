#!/bin/bash

# Exit if any command fails
set -e

# Update packages
sudo apt-get update -y

# Install required dependencies
sudo apt-get install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repo
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform
sudo apt-get update -y
sudo apt-get install -y terraform

# Verify installation
terraform -v
