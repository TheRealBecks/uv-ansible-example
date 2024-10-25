#!/usr/bin/env bash

#Define source directory of the Scrtipt
SOURCE_DIR=$(realpath "$(dirname -- "${BASH_SOURCE[0]}")")

# Build the local Podman/Docker container
docker build --tag uv-ansible-example "$SOURCE_DIR"
