#!/bin/bash
# scripts/test.sh
set -e

IMAGE_NAME=${IMAGE_NAME:-local/terraform}
TAG=${TAG:-1.13.0-aws-5.64.0}
FULL_IMAGE="$IMAGE_NAME:$TAG"

echo "Testing $FULL_IMAGE..."

# Version check
echo "✓ Testing version..."
docker run --rm "$FULL_IMAGE" version

# Provider check
echo "✓ Testing providers with config..."
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/main.tf" <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}
EOF

docker run --rm -v "$TEST_DIR:/workspace" -w /workspace "$FULL_IMAGE" init
docker run --rm -v "$TEST_DIR:/workspace" -w /workspace "$FULL_IMAGE" providers

# Debug mode check
echo "✓ Testing debug mode..."
docker run --rm "$FULL_IMAGE" debug -c "echo 'Debug mode works'"

echo "All tests passed! ✅"
