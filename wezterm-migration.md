# Windows Terminal + tmux → WezTerm 全面移行手順

再設計を前提に、現在の **二重 tmux**（外側 `nvim-dev` + 内側 `nvim-dev-term`）ワークフローを **WezTerm mux** に置き換えるための段階的手順書。

## 現状アーキテクチャ

```
Windows Terminal
  └─ WSL (Ubuntu-24.04)
       └─ 外側 tmux (nvim-dev)          ← .tmux.conf
            ├─ ペイン0: Neovim (--server)
            ├─ ペイン1: Agent (右 35%)
            └─ ペイン2: 内側 tmux        ← .tmux.term.conf (ソケット nvim-dev-term)
                 └─ タブ付きシェル (下部 25%)
```

## 目標アーキテクチャ

```
WezTerm (Windows ネイティブ)
  └─ WSL domain
       └─ WezTerm mux (nvim-dev ワークスペース)
            ├─ ペイン: Neovim (--server)
            ├─ ペイン: Agent (右 35%)
            └─ タブ群: シェル (下部領域相当)
```

## 移行の原則

1. **段階的に切り替える** — 各ステップで動作確認してから次へ進む
2. **tmux と並行運用できる期間を設ける** — ロールバック可能にする
3. **Neovim 連携は最後にまとめて切り替えない** — ペイン移動・フォーカス・IME は早期に検証する
4. **環境変数で新旧を切り替え可能にする** — 例: `NVIM_IN_WEZTERM=1`（`NVIM_IN_TMUX` の後継）

---

## Step 0: 事前準備と棚卸し

### やること

- [ ] WezTerm を Windows にインストール（[公式リリース](https://wezfurlong.org/wezterm/installation.html)）
- [ ] 現在の tmux ワークフローを文書化（本ファイル + 既存設定で足りるが、実際のキー操作をメモ）
- [ ] 移行対象ファイルの一覧を確認

| カテゴリ | 現ファイル | 移行後の想定 |
|---|---|---|
| 端末設定 | `terminal/settings.json` | `wezterm/wezterm.lua` |
| 外側 tmux | `tmux/.tmux.conf` | `wezterm/wezterm.lua`（キー・配色） |
| 内側 tmux | `tmux/.tmux.term.conf` | `wezterm/wezterm.lua`（タブ操作） |
| 起動スクリプト | `scripts/nvim-dev.sh` | `scripts/nvim-dev-wez.sh`（新規） |
| Neovim 連携 | `nvim/.../tmux-navigator.lua` | 削除 or WezTerm 向けに置換 |
| Neovim 連携 | `nvim/.../kill-session.lua` | WezTerm mux 終了ロジックに書き換え |
| Neovim 連携 | `nvim/.../scratch-cleanup.lua` | `NVIM_IN_WEZTERM` + フォーカス検証 |
| Neovim 連携 | `nvim/.../zenhan.lua` | そのまま or キー競合調整 |
| IME | `scripts/zenhan-off.sh` | `tmux send-keys` 依存を除去 |
| シェル | `bash/.bash_aliases` (`nvim_tmux`) | `nvim_wez` に再設計 |
| 配布 | `scripts/symlink.sh` | WezTerm 設定のコピー/リンク追加 |

### 完了条件

- WezTerm が起動し、WSL シェルが開ける
- 移行対象の依存関係を把握している

---

## Step 1: WezTerm 基本設定の骨格を作る

### やること

- [ ] `wezterm/` ディレクトリを dotfiles に作成
- [ ] `wezterm/wezterm.lua` の最小構成を書く
  - WSL ドメイン（`Ubuntu-24.04`, user `bahori1991`）
  - デフォルトシェル起動
  - 設定リロード（`Ctrl+Shift+R` 等）
- [ ] Windows 側への配置方法を決める
  - 案 A: `%USERPROFILE%\.wezterm.lua` から dotfiles を `dofile` で読み込む
  - 案 B: `wezterm/copy.sh` で `wezterm.lua` をコピー（`.bashrc` コメントの旧案を復活）
- [ ] `scripts/symlink.sh` に WezTerm 配布処理を追加（Step 9 で本番化してもよい）

### 参照する現設定

- `terminal/settings.json` — フォント `HakuMoto Console` 11pt、配色 `VS Code`

### 完了条件

- WezTerm 単体で WSL に入れる
- `wezterm.lua` を編集 → リロードで反映される

---

## Step 2: 見た目の移植（Windows Terminal → WezTerm）

### やること

- [ ] `terminal/settings.json` の配色を `color_schemes` に移植
  - background `#21252b`（WT）vs tmux の `#1e1e1e` — どちらを正とするか決める
- [ ] フォント設定を移植（ligature が必要なら有効化）
- [ ] 非アクティブペインの見た目を tmux に寄せる
  - 参考: `.tmux.conf` の `window-style` / `pane-border-style`
  - WezTerm: `inactive_pane_hsb`, `colors.tab_bar` 等
- [ ] タブバー位置・スタイルを決める（内側 tmux の上部タブバーに相当）

### 完了条件

- 配色・フォントが現環境と同等に見える
- アクティブ/非アクティブペインの区別がつく

---

## Step 3: キーバインド設計（WezTerm デフォルトとの競合解消）

### やること

- [ ] WezTerm デフォルトキーで tmux/Neovim と競合するものを無効化
  - 特に `Ctrl+Shift+矢印`（WezTerm ペイン移動 vs tmux の `C-S-h/j/k/l` リサイズ）
  - `Ctrl+h/j/k/l` をペイン移動に割り当て（後の Neovim 連携で使用）
- [ ] 外側 tmux のキーを WezTerm アクションにマッピング

| 現 tmux 操作 | WezTerm 相当 |
|---|---|
| `C-h/j/k/l` ペイン移動 | `ActivatePaneDirection` |
| `C-S-h/j/k/l` ペインリサイズ | `AdjustPaneSize` |
| `bind r` 設定リロード | `ReloadConfiguration` |

- [ ] 内側 tmux のタブ操作を WezTerm タブ操作にマッピング

| 現 tmux (`.tmux.term.conf`) | WezTerm 相当 |
|---|---|
| `M-t` 新規タブ | `SpawnTab` |
| `M-1`〜`M-9` タブ選択 | `ActivateTab` |
| `M-]` / `M-[` 次/前タブ | `ActivateTabRelative` |
| `M-w` タブ閉じる | `CloseCurrentTab` |
| `M-r` タブ名変更 | `PromptInputLine` + `RenameTab` |

### 完了条件

- WezTerm 単体でペイン分割・移動・リサイズができる
- タブの作成・切り替え・削除ができる
- Neovim へ渡すべきキーが WezTerm に飲み込まれない

---

## Step 4: nvim-dev レイアウトを WezTerm mux で再現

### やること

- [ ] `scripts/nvim-dev-wez.sh`（仮名）を新規作成
- [ ] 現 `scripts/nvim-dev.sh` のロジックを `wezterm cli` ベースに書き換え

| 現 tmux 処理 | WezTerm cli 相当（要公式ドキュメント確認） |
|---|---|
| `tmux has-session` | `wezterm cli list` / workspace 確認 |
| `tmux new-session -d` | `wezterm cli spawn` |
| `tmux split-window -h -p 35` | `wezterm cli split-pane --horizontal --percent 35` |
| `tmux split-window -v -p 25` | `wezterm cli split-pane --vertical --percent 25` |
| `tmux attach` | `wezterm cli attach`（または起動時 workspace 指定） |
| `tmux respawn-pane` | ペイン ID 指定で再 spawn |
| 内側 tmux タブ | 下部ペイン領域を WezTerm タブとして管理 |

- [ ] ワークスペース名 `nvim-dev` を固定
- [ ] Neovim サーバーソケット `${XDG_RUNTIME_DIR}/nvim-dev-${UID}.sock` は現状維持
- [ ] Agent コマンド `AGENT_CMD` 環境変数は現状維持

### レイアウト仕様（現行踏襲）

```
┌─────────────────────┬──────────┐
│                     │  Agent   │
│      Neovim         │  (35%)   │
│                     ├──────────┤
│                     │ Terminal │
│                     │  tabs    │
│                     │  (25%)   │
└─────────────────────┴──────────┘
```

### 完了条件

- `nvim-dev-wez.sh` 単体で 3 領域レイアウトが再現できる
- 既存セッションがある場合に再アタッチできる
- Neovim サーバーが落ちた場合に再起動できる（`ensure_editor_nvim` 相当）

---

## Step 5: Neovim ペイン移動の再設計（vim-tmux-navigator 置換）

### やること

- [ ] `vim-tmux-navigator` の役割を整理
  - Neovim 内: `<C-h/j/k/l>` でウィンドウ移動
  - Neovim 端: 同キーで tmux ペインへ移動
- [ ] 置換方針を決める（いずれか）

| 方針 | 概要 | 難易度 |
|---|---|---|
| A. WezTerm キーバインドのみ | Neovim 端は WezTerm がペイン移動を処理 | 低 |
| B. Neovim プラグイン新設 | `wezterm cli activate-pane-direction` を呼ぶ Lua | 中 |
| C. 既存 navigator を fork | tmux 通信部分を wezterm cli に差し替え | 中 |

- [ ] 推奨: **方針 A + B のハイブリッド**
  - WezTerm: ターミナルフォーカス時のペイン移動
  - Neovim: バッファ端で `wezterm cli` を呼んで隣ペインへ
- [ ] `nvim/lua/plugins/navigation/tmux-navigator.lua` を削除 or 置換
- [ ] `nvim/lua/plugins/init.lua` の import を更新

### 完了条件

- Neovim 内のウィンドウ移動が従来どおり動く
- Neovim の端から Agent / Terminal ペインへ `C-h/j/k/l` で移動できる
- Agent / Terminal から Neovim へ戻れる

---

## Step 6: フォーカスイベントと scratch-cleanup の検証

### やること

- [ ] `NVIM_IN_TMUX=1` を `NVIM_IN_WEZTERM=1` に移行（併用期間は両方サポート可）
- [ ] `nvim/lua/config/integration/scratch-cleanup.lua` を更新
  - 現状: tmux `focus-events on` による `FocusGained` / `FocusLost` 依存
  - WezTerm: ペイン切り替え時に Neovim へフォーカスイベントが届くか検証
- [ ] 届かない場合の代替を実装
  - `vim.o.autoread` + 手動 `checktime` トリガー
  - WezTerm の `PaneFocused` イベント（あれば）と連携
  - ポーリングは最終手段

### 完了条件

- ペイン切り替えで W13（ファイル変更警告）が不要に出ない
- `:checktime` 相当の挙動が破綻しない

---

## Step 7: IME（zenhan）連携の再設計

### やること

- [ ] 現状の二経路を整理
  - tmux: `Escape` → `zenhan-off.sh`（非 Neovim ペイン）
  - Neovim: `zenhan.lua` の `<Esc>` → `zenhan-off.sh`
- [ ] `scripts/zenhan-off.sh` から `tmux send-keys` を除去
  - シェルペインでは WezTerm の `SendKey` で Escape を送る設計に変更
- [ ] WezTerm 側に `Escape` キーバインドを追加
  - Neovim ペイン: キーをそのまま通過
  - それ以外: `zenhan.exe 0` 実行 + Escape 送信
  - Neovim ペイン判定は現 tmux の `is_vim` 相当のロジックを検討
- [ ] `nvim/lua/config/integration/zenhan.lua` は WSL 上でそのまま使えるか確認

### 完了条件

- シェル / Agent ペインで `Esc` 押下時に IME がオフになる
- Neovim ノーマルモードの `Esc` が壊れない

---

## Step 8: セッション終了ロジック（kill-session 置換）

### やること

- [ ] `nvim/lua/config/integration/kill-session.lua` を書き換え
  - 現状: `:qa` / `:qall` で `tmux kill-session -t nvim-dev`
  - 移行後: `wezterm cli kill-workspace nvim-dev` 等（要 API 確認）
- [ ] `NVIM_IN_WEZTERM` ガードに変更
- [ ] 誤爆防止: 他の WezTerm ウィンドウ/ワークスペースに影響しないこと

### 完了条件

- `nvim-dev` ワークスペース内で `:qa` すると開発環境全体が終了する
- 通常の `:q`（単一ファイル終了）ではワークスペースは残る

---

## Step 9: シェル統合（bash_aliases / 起動エイリアス）

### やること

- [ ] `bash/.bash_aliases` の `nvim_tmux` を `nvim_wez` に再設計

| 現ロジック | 移行後 |
|---|---|
| `NVIM_IN_TMUX` チェック | `NVIM_IN_WEZTERM` チェック |
| `TMUX` + `#S` = nvim-dev | WezTerm ワークスペース / ペイン ID 判定 |
| フォールバック → `nvim-dev.sh` | フォールバック → `nvim-dev-wez.sh` |

- [ ] `alias nvim="nvim_wez"` に切り替え（移行完了後）
- [ ] `scripts/symlink.sh` を更新
  - `terminal/settings.json` のコピーを WezTerm 配布に置き換え or 併記
  - tmux symlink は移行完了まで残す

### 完了条件

- 任意ディレクトリで `nvim` と打つと WezTerm 版 dev 環境が起動する
- dev 環境外では通常の `nvim` として動く

---

## Step 10: Windows 統合と本番切り替え

### やること

- [ ] Windows の既定ターミナルを WezTerm に変更（設定 → プライバシーとセキュリティ → 開発者向け → ターミナル）
- [ ] スタートメニュー / タスクバーのショートカットを WezTerm に変更
- [ ] 旧 Windows Terminal 設定のバックアップを取る
- [ ] 1〜2 週間の並行運用
  - 新: WezTerm + `nvim-dev-wez.sh`
  - 旧: Windows Terminal + `nvim-dev.sh`（ロールバック用）
- [ ] 問題なければ本番切り替え

### 完了条件

- 日常開発が WezTerm のみで回る
- ロールバック手順を一度実行できることを確認済み

---

## Step 11: クリーンアップ

### やること

- [ ] 不要になったファイルを削除 or アーカイブ

| ファイル | 処置 |
|---|---|
| `tmux/.tmux.conf` | 削除 or `archive/` へ |
| `tmux/.tmux.term.conf` | 削除 or `archive/` へ |
| `scripts/nvim-dev.sh` | 削除 or `nvim-dev-wez.sh` にリネーム統合 |
| `nvim/.../tmux-navigator.lua` | 削除 |
| `terminal/settings.json` | 削除 or 参照用に残す |
| `.cursor/rules/tmux-validation.mdc` | WezTerm 検証ルールに更新 |

- [ ] `scripts/symlink.sh` から tmux symlink を除去
- [ ] `lazy-lock.json` から `vim-tmux-navigator` を除去（`:Lazy sync`）
- [ ] README / 本ファイルのステータスを「完了」に更新

### 完了条件

- dotfiles 内に tmux 依存の実行パスが残っていない
- `updatesymlink` 後も意図どおり配布される

---

## 検証チェックリスト（各ステップ共通）

毎ステップの末尾で最低限確認する項目。

- [ ] WezTerm から WSL の Neovim が起動する
- [ ] Agent ペインで `agent` コマンドが動く
- [ ] Terminal タブで `cd` / シェル操作ができる
- [ ] `C-h/j/k/l` で全ペイン間を往復できる
- [ ] `Esc` で IME がオフになる（日本語入力時）
- [ ] `:qa` で dev 環境が終了する
- [ ] ペイン切り替えで Neovim の W13 が出ない
- [ ] 設定変更後にリロードで反映される

---

## ロールバック手順

移行中に問題が起きた場合:

1. Windows の既定ターミナルを Windows Terminal に戻す
2. `alias nvim="nvim_tmux"` に戻す（または `nvim-dev.sh` を直接実行）
3. `updatesymlink` で tmux symlink を復元
4. 既存の `tmux attach -t nvim-dev` で旧セッションに復帰（セッションが残っている場合）

---

## 想定リスクと対策

| リスク | 対策 |
|---|---|
| WezTerm cli の API が想定と異なる | Step 4 で早めに PoC。公式 docs / `wezterm cli help` を参照 |
| フォーカスイベントが Neovim に届かない | Step 6 で代替手段を用意してから先に進まない |
| キーバインドの奪い合い | Step 3 で `disable_default_key_bindings` を活用 |
| WSL 起動が遅くなる | `default_domain` を WSL に固定、不要な Windows プロファイルを減らす |
| 二重 tmux 廃止に伴う習慣の違和感 | 内側 tmux のキー（`M-t` 等）を WezTerm で同じ配列にする |

---

## 推奨実施順序（まとめ）

```
Step 0  準備
  ↓
Step 1  WezTerm 骨格
  ↓
Step 2  見た目移植
  ↓
Step 3  キーバインド設計
  ↓
Step 4  レイアウト再現（nvim-dev-wez.sh）  ← ここが最大の山場
  ↓
Step 5  ペイン移動（navigator 置換）
  ↓
Step 6  フォーカス / scratch-cleanup
  ↓
Step 7  zenhan / IME
  ↓
Step 8  kill-session
  ↓
Step 9  bash 統合
  ↓
Step 10 本番切り替え
  ↓
Step 11 クリーンアップ
```

---

## ステータス

| 項目 | 状態 |
|---|---|
| 手順書作成 | 完了 |
| Step 0〜11 実装 | 未着手 |

最終更新: 2026-07-13
