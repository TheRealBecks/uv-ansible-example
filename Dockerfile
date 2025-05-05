ARG DOCKER_PYTHON_VERSION=DOCKER_PYTHON_VERSION_is_not_set

FROM ghcr.io/astral-sh/uv:python${DOCKER_PYTHON_VERSION}-bookworm-slim

ARG DOCKER_PYTHON_VERSION

RUN update-ca-certificates

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# gcc and devel files are needed for 'ansible-pylibssh' compilation
# git is needed for the Ansible Galaxy requirements.yaml
# patch is needed for the arista.eos collection
RUN apt-get update
RUN apt-get install -y gcc libssh-dev git ssh

# Change the working directory to the `/uv-ansible-example` directory
WORKDIR /uv-ansible-example

# Install Python dependencies
RUN --mount=type=cache,destination=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,destination=uv.lock \
    --mount=type=bind,source=pyproject.toml,destination=pyproject.toml \
    uv sync --locked --no-install-project

# Copy the project into the image
ADD . .

# Sync the project
RUN --mount=type=cache,destination=/root/.cache/uv \
    uv sync --locked

# Activate the environment
ENV PATH="/uv-ansible-example/.venv/bin:$PATH"

# Install the Ansible requirements
RUN uv run ansible-galaxy install -r uv-ansible-example/requirements.yaml

# Create certificate folder needed for local dev Docker containers
RUN mkdir -p /usr/share/ca-certificates/company
