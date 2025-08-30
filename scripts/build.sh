#!/bin/bash
# scripts/build.sh
set -e

TF_VERSION=${TF_VERSION:-1.13.0}
AWS_PROVIDER_VERSION=${AWS_PROVIDER_VERSION:-5.64.0}
IMAGE_NAME=${IMAGE_NAME:-local/terraform}
TAG=${TAG:-${TF_VERSION}-aws-${AWS_PROVIDER_VERSION}}

echo "Building Terraform Docker image..."
echo "  Terraform: $TF_VERSION"
echo "  AWS Provider: $AWS_PROVIDER_VERSION"
echo "  Tag: $IMAGE_NAME:$TAG"

docker build -f images/terraform/Dockerfile \
 --build-arg TF_VERSION="$TF_VERSION" \
 --build-arg AWS_PROVIDER_VERSION="$AWS_PROVIDER_VERSION" \
 -t "$IMAGE_NAME:$TAG" \
 .

echo "Build complete: $IMAGE_NAME:$TAG"
