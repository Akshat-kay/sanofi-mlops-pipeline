#!/bin/bash
# Install dependencies
sudo apt update
sudo apt install -y python3-pip docker.io
pip install metaflow pandas scikit-learn fastapi uvicorn

# Initialize Terraform
cd ~/sanofi-mlops/infra
terraform init

# Create sample data
mkdir -p ~/sanofi-mlops/data/raw
echo "feature1,feature2,target\n1,2,3\n4,5,9" > ~/sanofi-mlops/data/raw/dataset.csv

# Start Docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
