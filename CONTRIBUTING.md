# Contributing to Terraform Docker

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/sanjeevma/terraform-docker.git`
3. Create a feature branch: `git checkout -b feature/your-feature`

## Development Setup

```bash
# Build the image
make build

# Run tests
make test

# Local development with docker-compose
docker-compose build
docker-compose run --rm terraform version
