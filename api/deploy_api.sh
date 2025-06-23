#!/bin/bash

# Clean up old containers
docker rm -f ml-api-container 2>/dev/null || true

# Build with correct context
docker build -t ml-api .

# Run with volume mount for models
docker run -d \
  --name ml-api-container \
  -p 8000:8000 \
  -v "$(pwd)/models:/app/models" \
  ml-api

# Check status
echo "Waiting for API to start..."
sleep 5
docker logs ml-api-container

# Test endpoint
curl -v -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"features": [1, 2]}'
