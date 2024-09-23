FROM python:3.12-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Change the working directory to the `/uv-ansible-example` directory
WORKDIR /uv-ansible-example

# Install Python dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project

# Copy the project into the image
ADD . .

# Sync the project
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen

# Activate the environment
ENV PATH="/uv-ansible-example/.venv/bin:$PATH"

# Install Linux packages
# SSH is needed to connect to Linux hosts with Ansible
RUN apt-get update
RUN apt-get install -y ssh

# Install the Ansible requirements
RUN ansible-galaxy install -r uv-ansible-example/requirements.yaml
