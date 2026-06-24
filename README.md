# Agents CLI & ADK 2.0 Dev Container テンプレート

このリポジトリは、Google の Agents CLI と ADK 2.0 (Agent Development Kit) を用いたエージェント開発環境を、Antigravity IDE（VS Code の Dev Containers 拡張機能を利用）から簡単に構築するためのテンプレートです。

## 特徴

- **Python 3.14 / uv 搭載**: 高速なパッケージマネージャである `uv` と、最新の安定版 Python 3.14 をサポートしています。
- **Agents CLI & SDK プリインストール**: コンテナのシステム Python 環境に `google-agents-cli` があらかじめインストールされており、コンテナ起動直後から `google-agents` コマンドや `import google.genai` がそのまま使用可能です。
- **.venv 構築不要**: 必要なライブラリはすべてコンテナ内のシステム環境に直接配置されるため、仮想環境 (`.venv`) をローカルに作成・構築・マウントする手間が一切ありません。ホストOS（Windows等）との競合も発生しません。
- **gcloud CLI 搭載**: Google Cloud 連携のための CLI を同梱。ホストマシンの認証情報が自動的に共有されます。
- **グローバルルールのマウント**: ホスト側のAntigravity（Gemini系エージェント）のグローバルルールをコンテナ内に安全かつオプショナルにマウント・共有可能です。
- **ADK自動セットアップ**: コンテナ起動時に Node.js (npx) のインストールから `google-agents-cli setup` までを自動で完了。エージェントがすぐにADKの仕様を理解できる状態になります。
- **MIT-0 ライセンス**: 著作権表記不要で、どなたでも自由に改変・コピー・再配布いただけます。

## 親プロジェクトへの導入手順

この環境を既存または新規の Python プロジェクトの `.devcontainer` として利用するには、親プロジェクトのルートディレクトリで以下のコマンドを実行し、Git サブモジュールとして追加します。

```bash
git submodule add <GitHubリポジトリのURL> .devcontainer
git submodule update --init --recursive
```

これにより、親プロジェクトの `.devcontainer/` 以下に本テンプレートの構成ファイルが配置されます。

## 事前準備

この開発環境を利用するには、ホストマシンに以下がインストールされている必要があります：

1. **Docker Desktop** (または WSL 2 等の Docker ランタイム)
2. **Antigravity IDE**
3. **VS Code "Dev Containers" 拡張機能** (必須):
   - Antigravity IDE の拡張機能ビュー (`Ctrl+Shift+X`) を開き、**`Dev Containers`** (ID: `ms-vscode-remote.remote-containers`) を検索してインストールします。
   - または、ブラウザで [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) からインストールするか、Antigravity IDE がインストールされている環境で [こちらのリンク(vscode:extension/ms-vscode-remote.remote-containers)](vscode:extension/ms-vscode-remote.remote-containers) をクリックして直接インストールページを開くことも可能です。

## 利用手順

### 1. Antigravity IDE でプロジェクトを開く
親プロジェクトのフォルダを Antigravity IDE で開きます。

### 2. コンテナの起動
Antigravity IDE の右下に表示されるポップアップ、またはコマンドパレット（`Ctrl+Shift+P`）から **「Dev Containers: Reopen in Container」**（コンテナで再度開く）を選択します。
自動的に Docker イメージのビルドとコンテナの起動が行われます。

### 3. 依存パッケージの自動同期 (オプション)
コンテナ起動時に、親プロジェクトに `requirements.txt` または `pyproject.toml` が配置されている場合、`devcontainer.json` が自動的にそれを検出し、コンテナのシステム環境へ依存関係をインストールします。

手動で追加のライブラリをインストールしたい場合は、コンテナ内のターミナルで `uv pip install --system <パッケージ名>` を実行します：

```bash
uv pip install --system langchain
```

### 4. Agents CLI の利用
コンテナ内のターミナルで `google-agents` コマンドを実行して、エージェントの作成やテストを開始できます。

```bash
google-agents --help
```

### 5. Google Cloud の認証
Google Cloud の認証は、コンテナ内（Antigravity IDE 統合ターミナルなど）で実行します。

コンテナ内のターミナルで以下のコマンドを実行し、表示される URL から Google アカウントにログインして認証を完了させます。

```bash
gcloud auth login
```

ログイン完了後、以下のコマンドで認証されたアカウントがアクティブになっていることを確認できます。

```bash
gcloud auth list
```

### 6. 親プロジェクトからのコマンド実行例
Antigravity IDE でプロジェクトを開きコンテナ内に入ると、統合ターミナル (`Ctrl+~`) は自動的にコンテナ内のシェルに接続されます。そのため、ホスト側を意識せずにそのままコマンドを実行できます。

```bash
# プロジェクト内の Python コードを実行
python main.py

# プリインストールされている google-agents コマンドを実行
google-agents --help
```

---

## 環境変数と機密情報の管理 (.env)

API キーやプロジェクトIDなどの環境変数は、プロジェクトのルートディレクトリに配置する `.env` ファイル、またはホストマシンの環境変数を通じてコンテナに自動的に引き継がれます。

### 1. 基本設定 (.env ファイルの作成)
テンプレートに含まれる `.env.example` を親プロジェクトのルートにコピーして `.env` ファイルを作成します。

```bash
cp .devcontainer/.env.example .env
```

### 2. 複数プロジェクト並行起動時のコンテナ名衝突防止
複数のプロジェクトでこのコンテナを並行して起動する場合、コンテナ名が重複すると起動エラーになります。

作成した `.env` ファイルの `COMPOSE_PROJECT_NAME` 変数にプロジェクト固有の名前を設定してください。コンテナ名が `[プロジェクト名]-app` として構築され、名前の衝突を回避できます（未設定の場合は親ディレクトリ名がデフォルトとして使用されます）。

```ini
COMPOSE_PROJECT_NAME=my-unique-agent-project
```

### 3. 機密情報の管理 (推奨される安全な方法)
`GEMINI_API_KEY` などのAPIキー（機密情報）を `.env` ファイルに直接書き込むと、誤って Git などのバージョン管理システムにコミットしてしまう危険性があります。

そのため、**機密情報はホストマシン（ご自身のPC）の環境変数に設定し、それをコンテナに引き継ぐ方法を強く推奨します。**

#### 設定手順：

1. **ホストマシン側で環境変数を設定します。**
   * **Windows (PowerShell) の場合**:
     ```powershell
     [System.Environment]::SetEnvironmentVariable('GEMINI_API_KEY', 'your-actual-api-key', 'User')
      # 設定を反映させるため、Antigravity IDE を一度完全に再起動してください
     ```
   * **Mac / Linux / WSL (bash/zsh) の場合**:
     `~/.bashrc` や `~/.zshrc` に以下を追記します。
     ```bash
     export GEMINI_API_KEY="your-actual-api-key"
     ```

2. **`.env` ファイルには引き継ぎ用の記述をします。**
   作成した `.env` ファイル内で、以下のように環境変数名をプレースホルダー表記にします。
   ```ini
   GEMINI_API_KEY=${GEMINI_API_KEY}
   GCP_PROJECT_ID=your-gcp-project-id
   ```
   これにより、Docker Compose 起動時にホストマシンの環境変数 `GEMINI_API_KEY` の値がコンテナ内に安全に注入されます。

### 4. グローバルルールのマウント設定 (HOST_GEMINI_CONFIG_DIR)
ホスト側にあるエージェント（Antigravity等）のグローバルルール（Global Customizations Root）を、コンテナ内の `/home/vscode/.gemini/config` にマウントして共有できます。

設定するには、`.env` ファイルにホスト側の設定フォルダの絶対パスを指定します。

- **Windows**: `HOST_GEMINI_CONFIG_DIR=C:\Users\<ユーザー名>\.gemini\config`
- **macOS/Linux**: `HOST_GEMINI_CONFIG_DIR=/Users/<ユーザー名>/.gemini/config` または `/home/<ユーザー名>/.gemini/config`

#### フォールバック機能（マウントしない場合）
マウントが不要な開発者の場合は、`.env` に `HOST_GEMINI_CONFIG_DIR` を記述しない（または空にする）ことで、プロジェクト内に自動生成される `./.gemini_config_dummy` ダミーフォルダをマウント先にフォールバックさせます。これにより、設定を省略した開発者でもエラーなしでコンテナが正常に構築されます。
