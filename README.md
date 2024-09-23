# A small Example for uv and Ansible

This example project is intended to be a real world example that can be used for small private projects but also company production setups.

Main features:
* Python environment with [`uv`](https://github.com/astral-sh/uv)
* Ansible
* HashiCorp Vault integration
* Python linting and formatting with [`ruff`](https://github.com/astral-sh/ruff)
* Docker development container with local `.env` file
* Docker production container with environment variables

Not yet finished features:
* A Gitlab example with a `.gitlab-ci.yml` file
* Usage of VS Code with a Docker development container without the need of a local Python environment

## Installation - Local Dev Environment

### Python Dev Environment for the IDE

Install `uv` for managing the Python environment:
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

`uv` can also be updated after the installation:
```
uv self update
```

Install the Python development environment:
```
uv sync --extra dev
```

Check which versions have been installed and locked for all platforms(*):
```
uv pip freeze
```

(*): All platforms except Windows as that platform is not compatible with `ansible-lint` anymore and therefore has been disabled in the `pyproject.toml` file.

### Environment Variables needed for Docker/Podman

Copy `.env.example` to `.env` and change the user settings:
```
cp .env.example .env
```

If your company uses intermediate and root certificates you can also add the path to your local certificate file(s) folder with the variable `COMPANY_CERTIFICATE_FOLDER` in the `.env` file. If you __don't need__ that feature you need to remove or comment the variable `COMPANY_CERTIFICATE_FOLDER` in that `.env` file.

### Docker/Podman Dev Container

You can use Docker or Podman. If using Podman it's recommended to also install the Docker aliases for Podman as `docker` commands will be used in the scripts.

Run `docker_local_dev_container_build.sh` to build the container:
```
./docker_local_dev_container_build.sh
```

Run `docker_local_dev_container_run.sh` to run the container in interactive mode:
```
./docker_local_dev_container_run.sh
```

Python commands can now be run with `uv run` in the Docker container:
```
uv run ansible-playbook test-playbook.yaml
```

## Installation - Remote Prod Environment

To be defined 😀 A Gitlab example will follow

## Python and Package Versions

The Python and package versions hasve been partly hardcoded into the `pyproject.toml` file.

### Python Version

The to be used Python version is `3.12`, but at least the bug fix version `3.12.5` shall be used for this project. As it's not good to accidentally break the production environment with Python version `3.13` that one has been excluded:
```
requires-python = ">=3.12.5,<3.13"
```

### Package Versions

The main packages have been partially hardcoded into the `pyproject.toml` file:
```
"ansible==10.4.*",
"ansible-core==2.17.*",
```
