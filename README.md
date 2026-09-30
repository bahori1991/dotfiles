# dotfiles

Bash / Neovim / tmux / lazygit / Git などの個人設定をまとめたリポジトリです。  
WSL2 上の Linux 環境を主な想定としていますが、Linux 単体でも利用できます。

## 含まれる設定

| 対象 | 配置 | リンク先 |
|------|------|----------|
| Bash | `bash/` | `~/.bashrc`, `~/.profile` など |
| Neovim | `nvim/` | `~/.config/nvim` |
| tmux | `tmux/` | `~/.config/tmux/tmux.conf` |
| lazygit | `lazygit/` | `~/.config/lazygit/config.yml` |
| lazydocker | `lazydocker/` | `~/.config/lazydocker/config.yml` |
| lazysql | `lazysql/` | `~/.config/lazysql/config.toml` |
| Podman | `containers/` | `~/.config/containers/containers.conf` |
| Git | `git/` | `GIT_CONFIG_GLOBAL` 経由で読み込み |
| Windows Terminal | `terminal/` | WSL 利用時のみ自動生成 |

## 前提環境

- **OS**: WSL2 + Ubuntu 24.04 推奨（Windows Terminal 連携を使う場合）
- **シェル**: Bash

## 1. 依存ツールのインストール

Ubuntu / WSL の例:

```bash
sudo apt update
sudo apt install -y \
  git tmux neovim keychain bash-completion curl unzip
```

以下は apt にない、またはバージョンが古い場合があります。必要に応じて [GitHub Releases](https://github.com/) などから `~/.local/bin` に配置してください。

| ツール | 用途 |
|--------|------|
| **Neovim** 0.10 以上 | エディタ本体（プラグイン管理: lazy.nvim） |
| **tmux** 3.x | ターミナル multiplexer |
| **lazygit** | tmux から `g` で起動 |
| **eza** | `ls` / `ll` / `la` エイリアス |
| **curl** | Neovim プラグイン rest.nvim（HTTP クライアント） |
| **unzip** | [sqls](https://github.com/sqls-server/sqls) バイナリ展開（SQL LSP） |
| **sqls** | PostgreSQL 向け SQL LSP（Mason ではなく `~/.local/bin` に配置） |
| **lazysql** | tmux から `S` で起動する TUI SQL クライアント（任意） |
| **podman** | OCI コンテナ（TS / C# 向け LSP 用 devcontainer、lazydocker 連携） |
| **lazydocker** | tmux から `D` で起動（Podman の API 経由） |
| **podman-docker**（任意） | `docker` コマンドを Podman 互換 CLI として使う（`apt install podman-docker`） |
| **Docker Compose v2** | Go 版 Compose（`podman compose` 用。apt の Python v1 ではなく GitHub バイナリを推奨） |

### Podman（rootless）と lazydocker

コンテナランタイムは **Docker Desktop / dockerd ではなく Podman（rootless）** を想定しています。

#### インストールと socket

```bash
sudo apt install -y podman podman-docker   # docker 互換 CLI が不要なら podman のみ
systemctl --user enable --now podman.socket
```

rootless の API socket は `${XDG_RUNTIME_DIR}/podman/podman.sock`（例: `/run/user/1000/podman/podman.sock`）です。

#### Bash との連携（`bash/.bashrc` / `bash/.bash_prompt`）

| 設定 | 内容 |
|------|------|
| `DOCKER_HOST` | 上記 socket が存在するとき `unix://…/podman.sock` を export（**対話シェルのみ**。`.bashrc` 先頭で非対話シェルは読み込まない） |
| `PODMAN_COMPOSE_PROVIDER` | `~/.local/bin/docker-compose`（Go 版 Compose v2 バイナリ。apt の v1 `/usr/bin/docker-compose` より優先） |
| プロンプト | `/run/.containerenv` があると `[container]`、WSL なら `[WSL]`、それ以外は `[host]`（旧 `[docker]` / `/.dockerenv` から Podman 向けに変更） |
| keychain | コンテナ内（`/run/.containerenv`）では SSH 鍵の keychain 読み込みをスキップ |

`lazydocker` は Docker API 互換クライアントのため、**対話シェルで `DOCKER_HOST` が設定された状態**で使います（tmux の `D` も同様）。

```bash
# 対話シェルで .bashrc 読み込み後
echo "$DOCKER_HOST"
podman ps
podman run --rm docker.io/library/hello-world   # 動作確認
```

`docker` コマンド（podman-docker）も同じ Podman バックエンドを使います。  
`docker compose` は **Podman の `compose` サブコマンド**（外部 Compose バイナリを呼び出す）として動き、`podman compose` と同等です。Docker Desktop の Compose プラグイン（`~/.docker/cli-plugins`）は、いまの `docker`→`podman` ラッパーでは使いません。

`.profile` からは Docker Desktop 向けの `DOCKER_CONFIG` export を削除しています（Podman では不要）。

#### Docker Compose（Go 版 v2 系）

Ubuntu apt の **`docker-compose`（Python v1）** は使わず、[Compose Releases](https://github.com/docker/compose/releases) から standalone バイナリを `~/.local/bin` に置きます（`.profile` で PATH 先頭）。  
Podman 4.x との相性を考え、**v2.40.3 など v2 系**を推奨します（v5 系は Podman を新しくする場合の候補）。

```bash
COMPOSE_VERSION=v2.40.3
mkdir -p ~/.local/bin
curl -fsSL \
  "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o ~/.local/bin/docker-compose
chmod +x ~/.local/bin/docker-compose
docker-compose version   # Docker Compose version v2.40.3
```

任意で apt の v1 を外す（PATH 競合の防止）:

```bash
sudo apt remove docker-compose
```

`podman compose` 実行時の `>>>> Executing external compose provider ...` 警告は、**Podman 4.9 では環境変数では消せません**。  
`containers/containers.conf` で `compose_warning_logs = false` を設定し、`symlink.sh` で `~/.config/containers/containers.conf` にリンクします（§4 参照）。

Compose バイナリのパスは `.bashrc` の `PODMAN_COMPOSE_PROVIDER` で指定しています。conf の `compose_providers` に寄せる場合は、どちらか一方に揃えてください（env が優先されます）。

#### 非対話シェル・スクリプト

cron や CI から Docker API 互換クライアントを使う場合は、自分で export してください。

```bash
export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
```

### sqls（SQL Language Server）のインストール

Mason の `sqls` パッケージは Go が必要なため、**GitHub のビルド済みバイナリ**を `~/.local/bin` に置きます（`.profile` で PATH に含まれます）。

```bash
mkdir -p ~/.local/bin
tmpdir=$(mktemp -d)
curl -fsSL -o "$tmpdir/sqls-linux.zip" \
  https://github.com/sqls-server/sqls/releases/download/v0.2.48/sqls-linux-0.2.48.zip
unzip -o "$tmpdir/sqls-linux.zip" -d "$tmpdir"
install -m 755 "$tmpdir/sqls" ~/.local/bin/sqls
rm -rf "$tmpdir"
sqls --version
```

Neovim から `:echo exepath('sqls')` でパスが表示されれば OK です。  
バージョン更新時は同手順で `~/.local/bin/sqls` を上書きしてください。

## 2. リポジトリのクローン

`~/.config/dotfiles` にクローンします。

```bash
mkdir -p ~/.config
git clone <リポジトリURL> ~/.config/dotfiles
```

## 3. ユーザー固有の設定

### Git ユーザー情報

```bash
cp ~/.config/dotfiles/git/config.local.example ~/.config/dotfiles/git/config.local
```

`git/config.local` を編集して、名前とメールアドレスを設定します。

```gitconfig
[user]
  name = Your Name
  email = you@example.com
```

このファイルは `.gitignore` 対象のため、リポジトリには含まれません。

### WSL / Windows ユーザー名（任意）

`scripts/user.sh` が Windows ユーザー名と WSL ユーザー名を自動検出します。  
検出できない場合は、ファイル内のコメントを参考に直接指定してください。

```bash
# scripts/user.sh 内の例
# WIN_USER=<Your Windows Username>
# WSL_USER=<Your WSL Username>
```

機械ごとの上書き用に `scripts/user.local.sh` を作成して export しても構いません（`.gitignore` 対象）。

## 4. シンボリックリンクの作成

設定ファイルをホームディレクトリへリンクします。

```bash
source ~/.config/dotfiles/scripts/symlink.sh
```

このスクリプトは以下を行います。

- `~/.bashrc`, `~/.profile` などを `bash/` にリンク
- `~/.config/nvim` を `nvim/` にリンク
- `~/.config/tmux/tmux.conf` を `tmux/tmux.conf` にリンク（`colors.conf` は `tmux.conf` から読み込まれます）
- `~/.config/lazygit/config.yml` をリンク
- `~/.config/lazydocker/config.yml` をリンク
- `~/.config/lazysql/config.toml` をリンク
- `~/.config/containers/containers.conf` を `containers/containers.conf` にリンク（Podman / Compose 警告抑制）
- WSL 利用時: Windows Terminal の `settings.json` をテンプレートから生成

設定を更新したあと再リンクする場合:

```bash
updatesymlink   # エイリアス（.bash_aliases で定義）
```

## 5. シェルの再読み込み

```bash
source ~/.profile
# または新しいターミナルを開く
```

## 6. Neovim の初回起動

```bash
nvim
```

初回起動時に [lazy.nvim](https://github.com/folke/lazy.nvim) が自動インストールされ、  
`lazy-lock.json` に記載されたプラグインがダウンロードされます。  
[Mason](https://github.com/mason-org/mason.nvim) 経由で `lua_ls` や `stylua` なども自動導入されます（`sqls` は Mason 対象外。上記「sqls のインストール」を参照）。

Treesitter パーサーのインストール（`sql` 含む）にも数分かかることがあります。

### HTTP クライアント（rest.nvim）

[rest.nvim](https://github.com/rest-nvim/rest.nvim) で `.http` ファイルから API リクエストを送れます。  
設定は `nvim/lua/plugins/rest-nvim.lua`、Treesitter の `http` パーサーは `nvim/lua/plugins/nvim-treesitter.lua` で初回起動時にインストールされます。

| 要件 | 内容 |
|------|------|
| Neovim | 0.10.1 以上（rest.nvim 公式要件） |
| 外部コマンド | `curl`（リクエスト実行に必須） |
| プラグイン依存 | `plenary.nvim`、`nvim-treesitter`（`http` パーサー） |

`.http` バッファ（filetype `http`）を開くと lazy.nvim が rest.nvim を読み込みます。

#### 主な操作

| 操作 | 説明 |
|------|------|
| `<leader>rr` | カーソル下のリクエストを実行（`:belowright horizontal Rest run`） |
| `:Rest run` | 同上 |
| `:Rest last` | 直前のリクエストを再実行 |
| `:Rest open` | 結果ペインを開く |
| `:Rest env select` | 現在の `.http` に紐付ける `.env` を選択 |
| `:Rest env show` | 登録済みの `.env` を表示 |

結果バッファでは `H` / `L` で結果ペインを切り替えられます（rest.nvim デフォルト）。

#### 環境変数（`.env`）

`vim.g.rest_nvim.env.enable = true` のため、プロジェクト直下からファイル名が `.*%.env.*` にマッチするファイルを探して変数を読み込みます（例: `.env`, `dev.env`）。  
HTTP ファイル内では `{{HOST}}` のように参照できます。紐付けを明示したい場合は `:Rest env select` または `:Rest env set {path}` を使います。

#### 設定の要点

- レスポンス body はフックで `gq` フォーマット有効（`response.hooks.format = true`）
- Cookie は rest.nvim のデータディレクトリに保存（デフォルト動作）
- ログレベルは `_log_level = "DEBUG"`（トラブル時は `:Rest logs` で確認）

`.http` ファイルの書き方は [IntelliJ HTTP Client 構文](https://www.jetbrains.com/help/idea/http-client-in-product-code-editor.html) に準じます。最小例:

```http
GET https://httpbin.org/get
Accept: application/json
```

カーソルをリクエスト行に置き `<leader>rr` で実行すると、下に水平分割された結果ウィンドウにステータス・統計・ body が表示されます。

### SQL LSP（sqls + blink.cmp）

PostgreSQL 向けに [sqls](https://github.com/sqls-server/sqls) を LSP として使い、[blink.cmp](https://github.com/saghen/blink.cmp) で補完します。  
**DB 接続情報は dotfiles に書かず**、プロジェクト直下の [`.lazysql.toml`](https://github.com/jorgerojas26/lazysql#local-configuration)（lazysql と同じ形式）から読み込みます。

| 要件 | 内容 |
|------|------|
| バイナリ | `~/.local/bin/sqls`（Mason 非使用） |
| ワークスペース | バッファから上方向に `.lazysql.toml` があるディレクトリが root（`after/lsp/sqls.lua` の `root_markers`） |
| 補完 | blink.cmp の LSP ソース（`mason-lspconfig` で capabilities 付与） |

#### 設定ファイルの役割

| ファイル | 役割 |
|----------|------|
| `nvim/after/lsp/sqls.lua` | プロジェクト root ごとに `sqls -config …` で起動 |
| `nvim/lua/config/databaseurl.lua` | `.lazysql.toml` の最初の `postgres` `[[database]]` の `URL` を sqls 接続形式に変換 |
| `nvim/lua/config/sqls-config.lua` | 接続 YAML を `stdpath("data")/sqls/<hash>/config.yml` に生成 |
| `nvim/lua/plugins/mason-lspconfig.lua` | `vim.lsp.enable("sqls")`（Mason 未インストールのため手動 enable） |

生成された sqls 用 config の例: `~/.local/share/nvim/sqls/*/config.yml`

#### プロジェクト側の `.lazysql.toml`

ルートに `.lazysql.toml` を置き、**上から最初の** `Provider = "postgres"` の `[[database]]` の `URL` を sqls が使います（tmux プレフィックス + `S` の lazysql と同じファイルで接続を揃えられます）。

```toml
[[database]]
Name = "Local development"
Provider = "postgres"
URL = "postgres://user:password@localhost:5432/db?sslmode=disable"
```

| 項目 | 内容 |
|------|------|
| URL 形式 | `postgres://` または `pg://`（user・DB 名・host は URL から取得） |
| `sslmode` | query の `?sslmode=…`（省略時は `disable`） |
| `${env:VAR}` | URL 内の環境変数参照に対応（Neovim 起動時の `os.getenv`） |

接続 URL にパスワードを含める場合は git 管理外にするか、`.gitignore` に `.lazysql.toml` を載せる運用を推奨します。

#### 使い方

1. `.lazysql.toml` があるプロジェクト配下の `.sql` を Neovim で開く（例: `migrations/foo.sql`）
2. `:LspInfo` または `:lua vim.print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))` で `sqls` が attach しているか確認
3. Insert モードでテーブル名などを入力し、blink.cmp の候補を確認（PostgreSQL が起動・接続可能であること）

`.lazysql.toml` のない場所の `.sql` では LSP は attach しません。接続が取れない場合は `[sqls]` の WARN が出て、補完は空の connections で起動します。

### LSP / Formatter / Lint（Podman コンテナ）

TypeScript / C# 向けの LSP・フォーマッタ・Lint は、**Node.js と .NET SDK を Podman（OCI）コンテナ内に置き、Neovim もコンテナ内で使う**前提で設定しています。  
WSL ホスト上の Neovim から、コンテナ内の Node.js / .NET SDK を直接使うことはできません。

環境判定は `nvim/lua/config/lsp-env.lua` の `in_container()` が行います。

| 条件 | 用途 |
|------|------|
| `/.dockerenv` が存在 | Docker 系 devcontainer |
| `/run/.containerenv` が存在 | Podman / OCI devcontainer |
| 環境変数 `DEVCONTAINER=true` | devcontainer ツールが明示した場合 |

いずれかを満たし、かつ Node.js または .NET SDK が PATH にあるとき TS/C# 向け LSP・Mason ツールが有効になります。  
Bash の `[container]` 表示と keychain スキップは **`/run/.containerenv` のみ**（`bash/.bash_prompt` / `bash/.bashrc`）。

| 環境 | 動作 |
|------|------|
| WSL ホスト | TS/C# 向け LSP・Lint プラグインは読み込まない。Mason も `roslyn` / `oxfmt` / `oxlint` をインストールしない |
| Podman コンテナ（Node.js あり） | `typescript-tools.nvim`、`oxfmt`、`nvim-lint`（oxlint）が有効 |
| Podman コンテナ（.NET SDK あり） | `roslyn.nvim`、`dotnet format` が有効 |

#### ツール一覧

| 種類 | ツール | Neovim 連携 | Mason | コンテナ側の要件 |
|------|--------|-------------|-------|------------------|
| LSP | SQL（PostgreSQL） | sqls + blink.cmp | なし（`~/.local/bin/sqls`） | ホスト WSL で利用可 |
| LSP | TypeScript | [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim) | なし（`ts_ls` は使わない） | Node.js |
| LSP | C# | [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) | `roslyn` | .NET SDK |
| Formatter | JS/TS 等 | [conform.nvim](https://github.com/stevearc/conform.nvim) + `oxfmt` | `oxfmt` | Node.js |
| Linter | JS/TS | [nvim-lint](https://github.com/mfussenegger/nvim-lint) + `oxlint` | `oxlint` | Node.js |
| Formatter | C# | conform.nvim + `dotnet format` | なし | .NET SDK（`dotnet format` は SDK 同梱） |

`mason-lspconfig` の `automatic_enable` では `roslyn` と `oxlint` を除外しています。  
LSP は各専用プラグイン、Lint は `nvim-lint` が担当するため、二重 attach を防ぐためです。

#### コンテナ側で必要なもの

**TypeScript 向け**

- Node.js / npm（PATH に通す）
- 各プロジェクトで `npm install`（`typescript` を devDependency に含めること。`typescript-tools` が `tsserver.js` を探します）

**C# 向け**

- .NET SDK 6 以降（`dotnet format` 利用時。Roslyn 本体は .NET 10 以上を推奨）
- `.sln` / `.csproj` が存在するディレクトリ（`dotnet format` の作業ディレクトリとして使用）

#### ホスト側の挙動

WSL ホストでは Neovim の起動エラーは出ません。  
ただし TS/JS ファイルを保存すると、formatter が見つからない旨の通知が出ることがあります（コンテナ外では format / lint が意図的にスキップされるため）。  
コンテナ専用で開発する場合は問題ありません。

#### コンテナ内での確認

```vim
:checkhealth        " 起動時エラーがないか
:Mason              " oxfmt, oxlint, roslyn が Installed か（コンテナ内のみ）
:LspInfo            " TS ファイル → typescript-tools / C# ファイル → roslyn
:ConformInfo        " oxfmt, dotnet_format が available か
```

## 7. tmux の初回起動

```bash
tmux
# または
tmux -f ~/.config/dotfiles/tmux/tmux.conf
```

tmux プラグイン（TPM 等）は使わず、`tmux.conf` と `colors.conf` のみで構成しています。

主な操作（プレフィックスは `Ctrl-t`。デフォルトの `Ctrl-b` ではありません）:

| 操作 | キー |
|------|------|
| ペイン移動 | `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l`（ウィンドウ最大化中は無効） |
| 垂直分割 | プレフィックス + `V` |
| 水平分割 | プレフィックス + `H` |
| ペイン名変更 | プレフィックス + `+` |
| lazygit | プレフィックス + `g` |
| lazydocker | プレフィックス + `D`（Podman 上のコンテナ。要 `DOCKER_HOST`） |
| lazysql | プレフィックス + `S`（現在のペインの cwd で新規ウィンドウ） |
| 設定再読み込み | プレフィックス + `r` |

コピーモードは vi キー。選択後 `y` で Windows クリップボード（`clip.exe`）へコピーします（WSL 想定）。

## 8. Windows Terminal の設定（WSL のみ・任意）

`scripts/symlink.sh` 実行時に、次のパスへ設定ファイルが生成されます。

```
/mnt/c/Users/<Windowsユーザー名>/AppData/Local/Packages/
  Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
```

WSL ディストリビューション名が `Ubuntu-24.04` 以外の場合は、  
`terminal/settings.json.template` 内のプロファイル名・GUID・`commandline` を環境に合わせて編集してから、  
再度 `source ~/.config/dotfiles/scripts/symlink.sh` を実行してください。

## 9. オプション設定

### SSH 鍵（keychain）

`.bashrc` は対話シェル起動時に `keychain` で SSH 鍵を読み込みます。  
`~/.ssh/id_rsa` または `~/.ssh/id_ed25519` を配置してください。  
Podman コンテナ内（`/run/.containerenv`）では keychain は実行しません。

### zenhan（日本語 IME 自動オフ）

Neovim / tmux のペイン移動時に IME をオフにする場合、Windows 側に zenhan を配置します。

```
C:\Users\<Windowsユーザー名>\bin\zenhan\zenhan.exe
```

zenhan が無くても他の設定は問題なく動作します。

### クリップボード（WSL）

tmux のコピー（`y`）は Windows クリップボード（`clip.exe`）へ送ります。  
WSL の Windows 連携が有効である必要があります。

## 動作確認チェックリスト

- [ ] `echo $GIT_CONFIG_GLOBAL` が `~/.config/dotfiles/git/config` を指している
- [ ] `ls -l ~/.config/nvim` が dotfiles へのシンボリックリンクになっている
- [ ] `git config user.name` / `git config user.email` が期待どおり
- [ ] `nvim` がエラーなく起動し、プラグインが読み込まれる
- [ ] `curl --version` が表示され、`.http` ファイルで `<leader>rr` がリクエストを実行できる
- [ ] `.http` を開いたときにハイライトがあり、`:Rest run` / `<leader>rr` で結果ペインが開く
- [ ] `exepath('sqls')` が `~/.local/bin/sqls` を指す
- [ ] `.lazysql.toml` 付きプロジェクトの `.sql` で `:LspInfo` に `sqls` が表示される
- [ ] （コンテナ内）`:Mason` で `oxfmt` / `oxlint` / `roslyn` が Installed になっている
- [ ] （コンテナ内）TS / C# ファイルで `:LspInfo` に LSP client が表示される
- [ ] `tmux` が起動し、プレフィックス + `r` で設定が再読み込みできる
- [ ] `lazygit` が `g` またはコマンドラインから起動できる
- [ ] `systemctl --user is-active podman.socket` が `active`
- [ ] 対話シェルで `echo "$DOCKER_HOST"` が `unix://…/podman/podman.sock` を指す
- [ ] `podman run --rm docker.io/library/hello-world` が成功する
- [ ] `podman compose version` が v2 系（例: v2.40.3）を表示し、外部プロバイダ警告が出ない（`containers.conf` の `compose_warning_logs = false`）
- [ ] `lazydocker` または tmux プレフィックス + `D` でコンテナ一覧が開く
- [ ] Podman コンテナ内でプロンプト先頭に `[container]` が表示される（ホストでは `[WSL]` など）

## 更新方法

```bash
cd ~/.config/dotfiles
git pull
source ~/.config/dotfiles/scripts/symlink.sh
```

Neovim プラグインの更新:

```bash
nvim
# コマンドモードで
:Lazy sync
```

## ディレクトリ構成

```
dotfiles/
├── bash/              # Bash 設定
├── git/               # Git 共通設定（config.local はローカルのみ）
├── lazygit/           # lazygit 設定
├── lazydocker/        # lazydocker 設定
├── lazysql/           # lazysql 設定
├── containers/        # Podman containers.conf（compose 警告抑制など）
├── nvim/              # Neovim 設定（lazy.nvim）
│   ├── after/lsp/     # LSP サーバー別設定（sqls.lua, lua_ls.lua など）
│   └── lua/
│       ├── config/    # キーマップ、databaseurl / sqls-config、LSP 環境判定など
│       └── plugins/   # プラグイン spec（rest-nvim.lua など）
├── scripts/           # symlink.sh, user.sh など
├── terminal/          # Windows Terminal テンプレート
└── tmux/
    ├── colors.conf    # カラーパレット（tmux.conf から source）
    └── tmux.conf      # メイン設定（プラグインなし）
```
