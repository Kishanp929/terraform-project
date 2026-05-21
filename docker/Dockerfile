FROM hashicorp/terraform:1.7.5

RUN apk add --no-cache \
    bash \
    curl \
    python3 \
    py3-pip \
    zip \
    unzip \
    docker-cli

# Install AWS CLI v2 (alpine compatible)
RUN pip install --break-system-packages awscli

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]