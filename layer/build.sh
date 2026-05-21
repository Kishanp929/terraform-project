#!/bin/bash
set -e
mkdir -p python
pip install -r requirements.txt -t python/
zip -r layer.zip python/
echo "layer.zip created successfully"