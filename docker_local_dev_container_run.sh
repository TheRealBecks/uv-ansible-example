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
    --mount type=bind,source=uv-ansible-example,destination=/uv-ansible-example/uv-ansible-example \
    --mount type=bind,source=${SSH_AUTH_SOCK},destination=${SSH_AUTH_SOCK},readonly \
    uv-ansible-example \
    bash
    
    
else
    # ...with COMPANY_CERTIFICATE_FOLDER environment variable
    docker run \
    -it \
    -w /uv-ansible-example/uv-ansible-example \
    --env-file .env \
    -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
    --mount type=bind,source=uv-ansible-example,destination=/uv-ansible-example/uv-ansible-example \
    --mount type=bind,source=${COMPANY_CERTIFICATE_FOLDER},destination=/usr/share/ca-certificates/company,readonly \
    --mount type=bind,source=${SSH_AUTH_SOCK},destination=${SSH_AUTH_SOCK},readonly \
    uv-ansible-example \
    bash
    
fi