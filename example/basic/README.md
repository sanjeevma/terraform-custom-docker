# examples/basic/README.md
# Basic S3 Bucket Example

Simple Terraform configuration to create an S3 bucket using the containerized setup.

## Usage

```bash
# Using Docker directly
docker run --rm -v $(pwd):/workspace -w /workspace \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION \
  local/terraform:1.13.0-aws-5.64.0 init

docker run --rm -v $(pwd):/workspace -w /workspace \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION \
  local/terraform:1.13.0-aws-5.64.0 plan

# Using docker-compose (from project root)
docker-compose run --rm terraform init
docker-compose run --rm terraform plan
