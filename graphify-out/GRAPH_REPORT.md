# Graph Report - dotfiles  (2026-11-06)

## Corpus Check
- 76 files · ~13,665 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: (none) 6, .toml 4, .conf 3)

## Summary
- 287 nodes · 285 edges · 54 communities (17 shown, 37 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 5 edges (avg confidence: 0.61)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c96ec92a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Lazygit Config
- Blink CMP Transforms
- Explorer Panel
- Lazydocker Config
- Bash Environment
- Git Branch Naming
- Lint and Semicolon Fixes
- Bash Prompt
- Lazygit Commit Display
- Focus Dimming
- Lualine Theme
- Dev Session Kill Script
- Lazygit Git Settings
- Bashrc Setup
- Claude and sqlmux Docs
- Dotfiles Setup Docs
- Windows User Detection
- CLAUDE.md Policies
- Claude Usage Script
- SQLS Config Writer
- Podman Container Docs
- Obsidian QA Logging
- Commit Message Script
- Claude Statusline Script
- Symlink Script
- Tmux Split Script
- Zenhan IME Script
- blink-cmp-transform.lua

## God Nodes (most connected - your core abstractions)
1. `gui` - 11 edges
2. `gui` - 11 edges
3. `theme` - 10 edges
4. `universal` - 9 edges
5. `sync_winhighlights()` - 7 edges
6. `customCommands` - 6 edges
7. `apply_focus_state()` - 5 edges
8. `commits` - 5 edges
9. `git` - 5 edges
10. `theme` - 5 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (54 total, 37 thin omitted)

### Community 0 - "Lazygit Config"
Cohesion: 0.08
Nodes (25): cherryPickCopy, pasteCommits, renameCommit, squashDown, customCommands, command, context, description (+17 more)

### Community 2 - "Blink CMP Transforms"
Cohesion: 0.23
Nodes (8): glob_has_markers(), has_marker_under_container_workspace(), M.has_solution_root(), M.dotnet_lsp_available(), M.has_dotnet(), M.has_node(), M.in_container(), M.typescript_lsp_available()

### Community 3 - "Explorer Panel"
Cohesion: 0.19
Nodes (13): entries_changed(), explorer_is_open(), has_solution_in_cwd(), keep_focus(), list_entries(), M.toggle(), M.use_solution_explorer(), same_entries() (+5 more)

### Community 4 - "Lazydocker Config"
Cohesion: 0.12
Nodes (15): gui, border, containerStatusHealthStyle, expandFocusedSidePanel, language, screenMode, scrollHeight, showBottomLine (+7 more)

### Community 5 - "Bash Environment"
Cohesion: 0.14
Nodes (13): BUILDKIT_PROGRESS, EDITOR, GIT_CONFIG_GLOBAL, LANG, LC_ALL, LESSHISTFILE, .bash_env.sh script, SQL_EDITOR (+5 more)

### Community 6 - "Git Branch Naming"
Cohesion: 0.14
Nodes (14): bahori, feature/*, fix/*, main, theme, activeBorderColor, authorColors, branchColors (+6 more)

### Community 7 - "Lint and Semicolon Fixes"
Cohesion: 0.16
Nodes (3): has_vite_plus(), M.resolve_ox_tool(), vite_plus_bin()

### Community 8 - "Bash Prompt"
Cohesion: 0.15
Nodes (5): .bash_prompt script, GIT_PS1_SHOWDIRTYSTATE, GIT_PS1_SHOWSTASHSTATE, GIT_PS1_SHOWUNTRACKEDFILES, GIT_PS1_SHOWUPSTREAM

### Community 9 - "Lazygit Commit Display"
Cohesion: 0.18
Nodes (11): show, gui, border, commitLength, mouseEvents, nerdFontVersion, showCommandLog, showDivergenceFromBaseBranch (+3 more)

### Community 10 - "Focus Dimming"
Cohesion: 0.40
Nodes (10): apply_focus_state(), is_csharp_explorer_win(), is_nvim_tree_win(), set_all_winhighlights(), set_pane_hl(), set_tree_hl(), set_winhighlight(), sync_tree_buf() (+2 more)

### Community 12 - "Dev Session Kill Script"
Cohesion: 0.39
Nodes (6): collect_dead_pids(), pane_alive(), pid_alive_in_container(), read_swap_pid(), remove_swaps_matching_pids(), nvim-dev-session-kill.sh script

### Community 13 - "Lazygit Git Settings"
Cohesion: 0.29
Nodes (7): git, autoFetch, log, mainBranches, parseEmoji, order, showGraph

### Community 16 - "Claude and sqlmux Docs"
Cohesion: 0.50
Nodes (5): Claude usage statusline, lazygit Claude commit message generation, sqlmux TUI SQL client, SQL LSP (sqls + blink.cmp), tmux keybindings

### Community 17 - "Dotfiles Setup Docs"
Cohesion: 0.40
Nodes (5): dotfiles repository overview, Managed config targets table, mdkite Markdown preview, symlink.sh deployment, Windows Terminal config generation

### Community 18 - "Windows User Detection"
Cohesion: 0.50
Nodes (3): .bash_user.sh script, WIN_USER, WSL_USER

### Community 19 - "CLAUDE.md Policies"
Cohesion: 0.50
Nodes (4): graphify trigger rule, Programming Assistance Policy, Safety and Operations Rules, Working Policy (CLAUDE.md)

### Community 52 - "blink-cmp-transform.lua"
Cohesion: 0.47
Nodes (3): M.single_to_double_quoted(), single_to_double_quoted(), transform_item()

## Ambiguous Edges - Review These
- `graphify trigger rule` → `Working Policy (CLAUDE.md)`  [AMBIGUOUS]
  .claude/CLAUDE.md · relation: conceptually_related_to

## Knowledge Gaps
- **26 isolated node(s):** `PODMAN_COMPOSE_PROVIDER`, `WIN_USER`, `WSL_USER`, `BUILDKIT_PROGRESS`, `EDITOR` (+21 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 181 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `gui` connect `Lazygit Commit Display` to `Lazygit Config`, `Git Branch Naming`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `PODMAN_COMPOSE_PROVIDER`, `WIN_USER`, `WSL_USER` to the rest of the system?**
  _26 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Lazygit Config` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._
- **Why does `theme` connect `Git Branch Naming` to `Lazygit Commit Display`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Should `Clipboard Integration` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._
- **Should `Lazydocker Config` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `graphify trigger rule` and `Working Policy (CLAUDE.md)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._