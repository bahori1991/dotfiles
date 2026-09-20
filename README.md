# dotfiles

Bash / Neovim / tmux / lazygit / Git などの個人設定をまとめたリポジトリです。  
WSL2 上の Linux 環境を主な想定としていますが、Linux 単体でも利用できます。

## 含まれる設定

| 対象 | 配置 | リンク先 |
|------|------|----------|
| Bash | `bash/` | `~/.bashrc`, `~/.profile` など |
| Neovim | `nvim/` | `~/.config/nvim` |
| tmux | `tmux/` | `~/.config/tmux/tmux.conf`, `~/.config/tmux/plugins` |
| lazygit | `lazygit/` | `~/.config/lazygit/config.yml` |
| Git | `git/` | `GIT_CONFIG_GLOBAL` 経由で読み込み |
| Windows Terminal | `terminal/` | WSL 利用時のみ自動生成 |

## 前提環境

- **OS**: WSL2 + Ubuntu 24.04 推奨（Windows Terminal 連携を使う場合）
- **シェル**: Bash
- **Git**: submodule を含むクローンが可能なこと

## 1. 依存ツールのインストール

Ubuntu / WSL の例:

```bash
sudo apt update
sudo apt install -y \
  git tmux neovim python3 python3-pip lsof keychain bash-completion curl
```

以下は apt にない、またはバージョンが古い場合があります。必要に応じて [GitHub Releases](https://github.com/) などから `~/.local/bin` に配置してください。

| ツール | 用途 |
|--------|------|
| **Neovim** 0.10 以上 | エディタ本体（プラグイン管理: lazy.nvim） |
| **tmux** 3.x | ターミナル multiplexer |
| **lazygit** | tmux から `g` で起動 |
| **eza** | `ls` / `ll` / `la` エイリアス |
| **pynvim** | tmux プラグイン treemux 用 |
| **curl** | Neovim プラグイン rest.nvim（HTTP クライアント） |

```bash
python3 -m pip install --user pynvim
```

## 2. リポジトリのクローン

`~/.config/dotfiles` にクローンします。submodule（tmux プラグイン）も同時に取得してください。

```bash
mkdir -p ~/.config
git clone --recurse-submodules <リポジトリURL> ~/.config/dotfiles
```

すでにクローン済みで submodule が空の場合:

```bash
cd ~/.config/dotfiles
git submodule update --init --recursive
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
- `~/.config/tmux/` 配下を `tmux/` にリンク
- `~/.config/lazygit/config.yml` をリンク
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
[Mason](https://github.com/mason-org/mason.nvim) 経由で `lua_ls` や `stylua` なども自動導入されます。

Treesitter パーサーのインストールにも数分かかることがあります。

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

### LSP / Formatter / Lint（Docker コンテナ）

TypeScript / C# 向けの LSP・フォーマッタ・Lint は、**Node.js と .NET SDK を Docker コンテナ内に置き、Neovim もコンテナ内で使う**前提で設定しています。  
WSL ホスト上の Neovim から、コンテナ内の Node.js / .NET SDK を直接使うことはできません。

環境判定は `nvim/lua/config/lsp-env.lua` が行います（`/.dockerenv` または `DEVCONTAINER=true`）。

| 環境 | 動作 |
|------|------|
| WSL ホスト | TS/C# 向け LSP・Lint プラグインは読み込まない。Mason も `roslyn` / `oxfmt` / `oxlint` をインストールしない |
| Docker コンテナ（Node.js あり） | `typescript-tools.nvim`、`oxfmt`、`nvim-lint`（oxlint）が有効 |
| Docker コンテナ（.NET SDK あり） | `roslyn.nvim`、`dotnet format` が有効 |

#### ツール一覧

| 種類 | ツール | Neovim 連携 | Mason | コンテナ側の要件 |
|------|--------|-------------|-------|------------------|
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

主な設定:

- プレフィックスキー: `Ctrl-t`（デフォルトの `Ctrl-b` ではありません）
- treemux サイドバー: `e`
- lazygit: `g`
- 設定再読み込み: プレフィックス + `r`

tmux プラグイン（tpm / vim-tmux-navigator / treemux）は submodule として同梱されているため、  
別途 TPM でのインストール操作は不要です。

treemux が動作しない場合は `pynvim` と `lsof` のインストールを確認してください。

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

`.bashrc` はログイン時に `keychain` で SSH 鍵を読み込みます。  
`~/.ssh/id_rsa` または `~/.ssh/id_ed25519` を配置してください。

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
- [ ] （コンテナ内）`:Mason` で `oxfmt` / `oxlint` / `roslyn` が Installed になっている
- [ ] （コンテナ内）TS / C# ファイルで `:LspInfo` に LSP client が表示される
- [ ] `tmux` が起動し、treemux（`e`）が開ける
- [ ] `lazygit` が `g` またはコマンドラインから起動できる

## 更新方法

```bash
cd ~/.config/dotfiles
git pull
git submodule update --init --recursive
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
├── nvim/              # Neovim 設定（lazy.nvim）
│   └── lua/
│       ├── config/    # キーマップ、LSP 環境判定、tmux 連携など
│       └── plugins/   # プラグイン spec（rest-nvim.lua など）
├── scripts/           # symlink.sh, user.sh など
├── terminal/          # Windows Terminal テンプレート
└── tmux/              # tmux 設定とプラグイン（submodule）
    ├── colors.conf    # カラーパレット（tmux.conf から source）
    ├── configs/       # treemux 用 Neovim 初期化（treemux_init.lua）
    └── plugins/
        ├── tpm/
        ├── treemux/
        └── vim-tmux-navigator/
```
