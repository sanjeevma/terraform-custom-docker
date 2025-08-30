# Terraform Docker Makefile

# Default versions
TF_VERSION ?= 1.13.0
AWS_PROVIDER_VERSION ?= 5.64.0
IMAGE_NAME ?= local/terraform
TAG ?= $(TF_VERSION)-aws-$(AWS_PROVIDER_VERSION)

.PHONY: build test clean push help

# Default target
all: build test

# Build the Docker image
build:
	docker build -f images/terraform/Dockerfile \
		--build-arg TF_VERSION=$(TF_VERSION) \
		--build-arg AWS_PROVIDER_VERSION=$(AWS_PROVIDER_VERSION) \
		-t $(IMAGE_NAME):$(TAG) \
		.

# Run sanity tests
test:
	@echo "Testing Terraform version..."
	docker run --rm $(IMAGE_NAME):$(TAG) version
	@echo "Testing with sample config..."
	@mkdir -p test-tf
	@echo 'terraform {\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "$(AWS_PROVIDER_VERSION)"\n    }\n  }\n}' > test-tf/main.tf
	docker run --rm -v $$(pwd)/test-tf:/workspace -w /workspace $(IMAGE_NAME):$(TAG) init
	@rm -rf test-tf
	@echo "All tests passed!"

# Clean up images and containers
clean:
	-docker rmi $(IMAGE_NAME):$(TAG)
	-docker system prune -f

# Push to registry (customize REGISTRY)
push: build
	@echo "To push, set REGISTRY variable:"
	@echo "make push REGISTRY=your-registry.com"
ifdef REGISTRY
	docker tag $(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
endif

# Create release tag
release: build test
	@echo "Creating release $(TAG)"
	git tag -a v$(TAG) -m "Release $(TAG)"
	@echo "Run 'git push origin v$(TAG)' to publish"

# Show help
help:
	@echo "Terraform Docker Build"
	@echo ""
	@echo "Targets:"
	@echo "  build    - Build Docker image"
	@echo "  test     - Run sanity tests"
	@echo "  clean    - Clean up images"
	@echo "  push     - Push to registry"
	@echo "  release  - Tag release"
	@echo "  help     - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  TF_VERSION=$(TF_VERSION)"
	@echo "  AWS_PROVIDER_VERSION=$(AWS_PROVIDER_VERSION)"
	@echo "  IMAGE_NAME=$(IMAGE_NAME)"
	@echo "  TAG=$(TAG)"
