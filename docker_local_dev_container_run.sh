#!/usr/bin/env bash

#Define source directory of the Scrtipt
SOURCE_DIR=$(realpath "$(dirname -- "${BASH_SOURCE[0]}")")

# Check if user has set '.env' file
if [ ! -f "${SOURCE_DIR}/.env" ]; then
    echo "Error: Specify your \".env\" file in \"${SOURCE_DIR}\" first!"
    exit 1
fi

# Read all variables as 'export'
set -a
source "${SOURCE_DIR}/.env"
set +a

# Start Podman/Docker in interactive mode...
if [ -z ${COMPANY_CERTIFICATE_FOLDER+COMPANY_CERTIFICATE_FOLDER} ]; then
    # ...without COMPANY_CERTIFICATE_FOLDER environment variable
    docker run \
        -it \
        -w "/uv-ansible-example/uv-ansible-example" \
        --env-file "${SOURCE_DIR}/.env" \
        --security-opt label=disable \
        -e SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" \
        --mount type=bind,source="${SSH_AUTH_SOCK}",destination="${SSH_AUTH_SOCK}",readonly \
        --mount type=bind,source="${SOURCE_DIR}/uv-ansible-example",destination="/uv-ansible-example/uv-ansible-example" \
        uv-ansible-example \
        bash
else
    # ...with COMPANY_CERTIFICATE_FOLDER environment variable
    docker run \
        -it \
        -w "/uv-ansible-example/uv-ansible-example" \
        --env-file "${SOURCE_DIR}/.env" \
        --security-opt label=disable \
        -e SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" \
        --mount type=bind,source="${SSH_AUTH_SOCK}",destination="${SSH_AUTH_SOCK}",readonly \
        --mount type=bind,source="${SOURCE_DIR}/uv-ansible-example",destination="/uv-ansible-example/uv-ansible-example" \
        --mount type=bind,source="${COMPANY_CERTIFICATE_FOLDER}",destination="/usr/share/ca-certificates/company",readonly \
        uv-ansible-example \
        bash
fi
