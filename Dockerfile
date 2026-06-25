FROM mcr.microsoft.com/devcontainers/python:3.14-bookworm

# 公式イメージから uv をインストール
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# google-agents-cli を root 権限でシステムの Python 環境にインストール
RUN uv pip install --system google-agents-cli

# ベースイメージ（devcontainers）側であらかじめ定義されている vscode ユーザーをそのまま使用します
USER vscode
WORKDIR /workspace

CMD ["/bin/bash"]
