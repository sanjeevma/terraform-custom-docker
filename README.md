# Terraform Docker

[![CI](https://github.com/sanjeevma/terraform-custom-docker/workflows/CI/badge.svg)](https://github.com/sanjeevma/terraform-custom-docker/actions)
[![Release](https://github.com/sanjeevma/terraform-custom-docker/workflows/Release/badge.svg)](https://github.com/sanjeevma/terraform-custom-docker/actions)
[![Docker Image](https://ghcr-badge.deta.dev/sanjeevma/terraform-custom-docker/latest_tag?trim=major&label=latest)](https://github.com/sanjeevma/terraform-custom-docker/pkgs/container/terraform-custom-docker)

Production-ready Terraform container with pre-baked AWS provider for faster initialization.
## Features

- **Terraform 1.13.0** on Alpine Linux base
- **Pre-cached AWS Provider 5.64.0** via filesystem mirror
- **Non-root user** for security
- **Multi-platform support** (linux/amd64, linux/arm64)
- **Plugin caching** for performance
- **Debug mode** for troubleshooting

## Quick Start

```bash
# Build the image
docker build -f images/terraform/Dockerfile \
  --build-arg TF_VERSION=1.13.0 \
  --build-arg AWS_PROVIDER_VERSION=5.64.0 \
  -t local/terraform:1.13.0-aws \
  .

# Run Terraform commands
docker run --rm -v $(pwd):/workspace -w /workspace \
  local/terraform:1.13.0-aws init

docker run --rm -v $(pwd):/workspace -w /workspace \
  local/terraform:1.13.0-aws plan
```

## Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `TF_VERSION` | `1.13.0` | Terraform version |
| `AWS_PROVIDER_VERSION` | `5.64.0` | AWS provider version |

## Usage Examples

### Basic Commands
```bash
# Check version
docker run --rm local/terraform:1.13.0-aws version

# List providers
docker run --rm -v $(pwd):/workspace -w /workspace \
  local/terraform:1.13.0-aws providers

# Format code
docker run --rm -v $(pwd):/workspace -w /workspace \
  local/terraform:1.13.0-aws fmt
```

### Debug Mode
```bash
# Enter debug shell
docker run --rm -it local/terraform:1.13.0-aws debug
```

### With Environment Variables
```bash
# Pass AWS credentials
docker run --rm \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION \
  -v $(pwd):/workspace -w /workspace \
  local/terraform:1.13.0-aws apply
```

## File Structure

```
.
├── images/terraform/
│   ├── Dockerfile           # Multi-stage build with provider caching
│   └── docker-entrypoint.sh # Entry script with debug mode
└── README.md               # This file
```

## How It Works

1. **Provider Pre-caching**: AWS provider is downloaded and mirrored during build
2. **Filesystem Mirror**: Terraform uses local provider cache instead of downloading
3. **Plugin Cache**: Shared plugin cache for faster subsequent runs
4. **Security**: Runs as non-root user `terraform` (UID 1000)

## Testing

```bash
# Quick sanity check
docker run --rm local/terraform:1.13.0-aws version

# Full test with sample config
mkdir test-tf && cd test-tf
cat > main.tf <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}
EOF

docker run --rm -v $(pwd):/workspace -w /workspace \
  local/terraform:1.13.0-aws init
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## License

See [LICENSE](LICENSE) file for details.
