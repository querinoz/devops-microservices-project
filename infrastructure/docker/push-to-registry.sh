#!/bin/bash
# Docker Registry Configuration Script
# Use this to push images to a private registry

REGISTRY_URL="${DOCKER_REGISTRY:-localhost:5000}"
SERVICE_A_IMAGE="service-a"
SERVICE_B_IMAGE="service-b"

echo "Tagging images for registry: $REGISTRY_URL"

# Tag images
docker tag ${SERVICE_A_IMAGE}:latest ${REGISTRY_URL}/${SERVICE_A_IMAGE}:latest
docker tag ${SERVICE_B_IMAGE}:latest ${REGISTRY_URL}/${SERVICE_B_IMAGE}:latest

echo "Pushing images to registry..."

# Push images
docker push ${REGISTRY_URL}/${SERVICE_A_IMAGE}:latest
docker push ${REGISTRY_URL}/${SERVICE_B_IMAGE}:latest

echo "✅ Images pushed successfully!"
