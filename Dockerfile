FROM mcr.microsoft.com/devcontainers/python:3.14-bookworm

# Install uv from official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install google-agents-cli to system Python environment as root
RUN uv pip install --system google-agents-cli

# Use vscode user (pre-configured in devcontainers images)
USER vscode
WORKDIR /workspace

CMD ["/bin/bash"]
