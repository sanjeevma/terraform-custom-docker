# images/terraform/Dockerfile
# Terraform 1.13.0 + pre-baked AWS provider (filesystem mirror) on Alpine base

ARG TF_VERSION=1.13.0
ARG AWS_PROVIDER_VERSION=5.64.0
FROM hashicorp/terraform:${TF_VERSION}

# Re-declare args for use after FROM
ARG TF_VERSION
ARG AWS_PROVIDER_VERSION

# Non-root user (Alpine)
ARG USER=terraform
ARG UID=1000
ARG GID=1000
RUN addgroup -g ${GID} ${USER} \
 && adduser -D -u ${UID} -G ${USER} -h /home/${USER} -s /bin/sh ${USER}

ENV HOME=/home/${USER}
ENV TF_IN_AUTOMATION=true
ENV TF_PLUGIN_CACHE_DIR=/opt/terraform/plugin-cache

RUN mkdir -p /opt/terraform/provider-mirror /opt/terraform/plugin-cache \
 && chown -R ${USER}:${USER} /opt/terraform

# Bake AWS provider into filesystem mirror (avoid TF_CLI_CONFIG_FILE until after mirror)
USER ${USER}
WORKDIR /tmp/aws-module
RUN cat > versions.tf <<EOF
terraform {
  required_version = ">= ${TF_VERSION}"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${AWS_PROVIDER_VERSION}"
    }
  }
}
EOF

RUN terraform init -backend=false \
 && terraform providers lock \
      -platform=linux_amd64 \
      -platform=linux_arm64 \
 && terraform providers mirror /opt/terraform/provider-mirror

# Configure Terraform to use baked mirror; then warm cache
USER root
RUN printf '%s\n' \
'provider_installation {' \
'  filesystem_mirror {' \
'    path    = "/opt/terraform/provider-mirror"' \
'    include = ["registry.terraform.io/hashicorp/*"]' \
'  }' \
'  direct {}' \
'}' > /etc/terraformrc

ENV TF_CLI_CONFIG_FILE=/etc/terraformrc
USER ${USER}
RUN TF_PLUGIN_CACHE_DIR=/opt/terraform/plugin-cache terraform -chdir=/tmp/aws-module init -backend=false

# Cleanup
USER root
RUN rm -rf /tmp/aws-module

WORKDIR ${HOME}


COPY images/terraform/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# finally switch to non-root
USER ${USER}

ENTRYPOINT ["/bin/sh", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["--help"]
