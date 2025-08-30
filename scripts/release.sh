#!/bin/bash
# scripts/release.sh
set -e

VERSION=${1:-$(cat VERSION 2>/dev/null || echo "1.0.0")}
IMAGE_NAME=${IMAGE_NAME:-local/terraform}
REGISTRY=${REGISTRY:-}

echo "Creating release $VERSION..."

# Build and test
./scripts/build.sh
./scripts/test.sh

# Tag release
git tag -a "v$VERSION" -m "Release $VERSION"

# Push to registry if specified
if [ -n "$REGISTRY" ]; then
  echo "Pushing to $REGISTRY..."
  docker tag "$IMAGE_NAME:$TAG" "$REGISTRY/$IMAGE_NAME:$TAG"
  docker push "$REGISTRY/$IMAGE_NAME:$TAG"
fi

echo "Release $VERSION ready!"
echo "Run: git push origin v$VERSION"
