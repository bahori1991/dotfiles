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
  git tmux neovim python3 python3-pip lsof keychain bash-completion
```

以下は apt にない、またはバージョンが古い場合があります。必要に応じて [GitHub Releases](https://github.com/) などから `~/.local/bin` に配置してください。

| ツール | 用途 |
|--------|------|
| **Neovim** 0.10 以上 | エディタ本体（プラグイン管理: lazy.nvim） |
| **tmux** 3.x | ターミナル multiplexer |
| **lazygit** | tmux から `g` で起動 |
| **eza** | `ls` / `ll` / `la` エイリアス |
| **pynvim** | tmux プラグイン treemux 用 |

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
├── scripts/           # symlink.sh, user.sh など
├── terminal/          # Windows Terminal テンプレート
└── tmux/              # tmux 設定とプラグイン（submodule）
    └── plugins/
        ├── tpm/
        ├── treemux/
        └── vim-tmux-navigator/
```
