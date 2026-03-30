#!/bin/bash
set -e

echo "Starting Local Environment Setup..."

# 1. Check if Kind is installed
if ! command -v kind &> /dev/null; then
    echo "Kind is not installed. Please install it first."
    exit 1
fi

# 2. Create Cluster
kind create cluster --name notify-cluster || echo "Cluster already exists"

# 3. Build Docker Image
echo "Building Docker Image..."
make docker-build

# 4. Load Image into Kind (Crucial for local K8s)
kind load docker-image notify-engine:latest --name notify-cluster

# 5. Deploy via Helm
echo "Deploying to Kubernetes..."
make deploy-local

echo "Setup Complete! Run 'kubectl get pods' to see your engine."