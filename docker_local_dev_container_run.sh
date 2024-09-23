#!/usr/bin/env bash

# Check if user has set '.env' file
if [ ! -f .env ]; then
    echo "Error: Specify your '.env' file first!"
    exit 1
fi

# Read all variables as 'export'
set -a
source .env
set +a

# Start Podman/Docker in interactive mode...
if [ -z ${COMPANY_CERTIFICATE_FOLDER+COMPANY_CERTIFICATE_FOLDER} ]
then
    # ...without COMPANY_CERTIFICATE_FOLDER environment variable
    docker run \
    -it \
    -w /uv-ansible-example/uv-ansible-example \
    --env-file .env \
    -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
    -v uv-ansible-example:/uv-ansible-example/uv-ansible-example \
    -v ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK} \
    uv-ansible-example \
    bash
    
    
else
    # ...with COMPANY_CERTIFICATE_FOLDER environment variable
    docker run \
    -it \
    -w /uv-ansible-example/uv-ansible-example \
    --env-file .env \
    -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
    -v uv-ansible-example:/uv-ansible-example/uv-ansible-example \
    -v ${COMPANY_CERTIFICATE_FOLDER}:/usr/share/ca-certificates/company \
    -v ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK} \
    uv-ansible-example \
    bash
    
fi