# Graph Report - dotfiles  (2026-11-04)

## Corpus Check
- 78 files · ~15,056 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: (none) 6, .toml 4, .conf 3)

## Summary
- 306 nodes · 311 edges · 52 communities (15 shown, 37 thin omitted)
- Extraction: 98% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.6)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f906ffc1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- universal
- gui
- explorer.lua
- gui
- lazysql → sqlmux 移行手順
- .bash_env.sh
- lsp-env.lua
- .bash_prompt
- databaseurl.lua
- focus-dim.lua
- lualine.lua
- nvim-dev-session-kill.sh
- git
- .bashrc
- blink-cmp-transform.lua
- Implementation owned by user policy
- .bash_user.sh
- claude-usage.sh
- Container-only TS/C# LSP policy
- log-qa-to-obsidian.sh
- generate-commit-msg.sh
- claude-statusline.sh
- symlink.sh
- tmux-split.sh
- zenhan-off.sh
- rest.nvim HTTP client

## God Nodes (most connected - your core abstractions)
1. `lazysql → sqlmux 移行手順` - 13 edges
2. `gui` - 11 edges
3. `gui` - 11 edges
4. `theme` - 10 edges
5. `universal` - 9 edges
6. `sync_winhighlights()` - 7 edges
7. `customCommands` - 6 edges
8. `apply_focus_state()` - 5 edges
9. `parse_postgres_url()` - 5 edges
10. `commits` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Implementation owned by user policy` --conceptually_related_to--> `lazygit Claude commit message generation`  [AMBIGUOUS]
  .claude/CLAUDE.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Container-based LSP and tooling** — readme_lsp_container_policy, readme_podman_rootless, readme_sqls_lsp [INFERRED 0.75]

## Communities (52 total, 37 thin omitted)

### Community 0 - "universal"
Cohesion: 0.08
Nodes (25): cherryPickCopy, pasteCommits, renameCommit, squashDown, customCommands, command, context, description (+17 more)

### Community 1 - "gui"
Cohesion: 0.08
Nodes (25): bahori, feature/*, fix/*, main, show, gui, border, commitLength (+17 more)

### Community 3 - "explorer.lua"
Cohesion: 0.18
Nodes (13): entries_changed(), explorer_is_open(), has_solution_in_cwd(), keep_focus(), list_entries(), M.toggle(), M.use_solution_explorer(), same_entries() (+5 more)

### Community 4 - "gui"
Cohesion: 0.12
Nodes (15): gui, border, containerStatusHealthStyle, expandFocusedSidePanel, language, screenMode, scrollHeight, showBottomLine (+7 more)

### Community 5 - "lazysql → sqlmux 移行手順"
Cohesion: 0.12
Nodes (16): 0. 調査結果（前提）, 10. リスクと未確認事項, 1. 事前準備（バックアップ）, 2. sqlmux のインストールと確認, 3-1. 現在の接続先を棚卸しする, 3-2. `~/.config/sqlmux/connections.toml` を作成する, 3-3. 接続テスト, 3. 接続情報の移行 (+8 more)

### Community 6 - ".bash_env.sh"
Cohesion: 0.14
Nodes (13): BUILDKIT_PROGRESS, EDITOR, GIT_CONFIG_GLOBAL, LANG, LC_ALL, LESSHISTFILE, .bash_env.sh script, SQL_EDITOR (+5 more)

### Community 7 - "lsp-env.lua"
Cohesion: 0.10
Nodes (11): glob_has_markers(), has_marker_under_container_workspace(), M.has_solution_root(), M.dotnet_lsp_available(), M.has_dotnet(), M.has_node(), M.in_container(), M.typescript_lsp_available() (+3 more)

### Community 8 - ".bash_prompt"
Cohesion: 0.15
Nodes (5): .bash_prompt script, GIT_PS1_SHOWDIRTYSTATE, GIT_PS1_SHOWSTASHSTATE, GIT_PS1_SHOWUNTRACKEDFILES, GIT_PS1_SHOWUPSTREAM

### Community 9 - "databaseurl.lua"
Cohesion: 0.27
Nodes (10): expand_env_in_url(), find_lazysql_toml(), first_postgres_url_in_lazysql(), M.connections_for_root(), parse_postgres_url(), parse_sslmode_from_query(), trim_line(), url_decode() (+2 more)

### Community 10 - "focus-dim.lua"
Cohesion: 0.40
Nodes (10): apply_focus_state(), is_csharp_explorer_win(), is_nvim_tree_win(), set_all_winhighlights(), set_pane_hl(), set_tree_hl(), set_winhighlight(), sync_tree_buf() (+2 more)

### Community 12 - "nvim-dev-session-kill.sh"
Cohesion: 0.39
Nodes (6): collect_dead_pids(), pane_alive(), pid_alive_in_container(), read_swap_pid(), remove_swaps_matching_pids(), nvim-dev-session-kill.sh script

### Community 13 - "git"
Cohesion: 0.29
Nodes (7): git, autoFetch, log, mainBranches, parseEmoji, order, showGraph

### Community 16 - "blink-cmp-transform.lua"
Cohesion: 0.47
Nodes (3): M.single_to_double_quoted(), single_to_double_quoted(), transform_item()

### Community 17 - "Implementation owned by user policy"
Cohesion: 0.40
Nodes (3): Claude usage statusline, lazygit Claude commit message generation, symlink.sh deployment

### Community 18 - ".bash_user.sh"
Cohesion: 0.50
Nodes (3): .bash_user.sh script, WIN_USER, WSL_USER

## Ambiguous Edges - Review These
- `lazygit Claude commit message generation` → `Implementation owned by user policy`  [AMBIGUOUS]
  .claude/CLAUDE.md · relation: conceptually_related_to

## Knowledge Gaps
- **23 isolated node(s):** `PODMAN_COMPOSE_PROVIDER`, `WIN_USER`, `WSL_USER`, `BUILDKIT_PROGRESS`, `EDITOR` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 193 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `gui` connect `gui` to `universal`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **What connects `PODMAN_COMPOSE_PROVIDER`, `WIN_USER`, `WSL_USER` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `universal` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._
- **Should `gui` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._
- **Should `config/init.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._
- **Should `gui` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `lazygit Claude commit message generation` and `Implementation owned by user policy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._