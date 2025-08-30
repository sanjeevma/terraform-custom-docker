# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup
- Multi-architecture support planning

## [1.0.0] - 2025-08-30

### Added
- Terraform 1.13.0 Docker image with Alpine base
- Pre-baked AWS Provider 5.64.0 via filesystem mirror
- Non-root user security (terraform:1000)
- Plugin caching for improved performance
- Debug mode via entrypoint script
- Multi-platform build support (linux/amd64, linux/arm64)
- Docker Compose configuration for local development
- Makefile for build automation
- Comprehensive test suite
- Example configurations (basic S3, infrastructure)
- CI/CD workflows for automated builds
- Documentation and contributing guidelines

### Security
- Container runs as non-root user
- Minimal Alpine base image
- No sensitive data baked into image

[Unreleased]: https://github.com/yourusername/terraform-docker/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/terraform-docker/releases/tag/v1.0.0
