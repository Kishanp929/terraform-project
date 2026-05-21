#!/bin/bash
set -e

echo "==> Building Lambda layer..."
cd /workspace/layer
pip install --break-system-packages -r requirements.txt -t python/
zip -r layer.zip python/
echo "Layer built: $(du -sh layer.zip)"

echo "==> Running Terraform..."
cd /workspace/terraform
terraform init -input=false
terraform validate
terraform apply -auto-approve -input=false

echo "==> Done! Outputs:"
terraform output