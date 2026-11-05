# Graph Report - dotfiles  (2026-11-05)

## Corpus Check
- 75 files · ~13,523 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 16 file(s) not represented in the graph (top: (none) 6, .toml 4, .conf 3)

## Summary
- 288 nodes · 287 edges · 53 communities (16 shown, 37 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.7)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f3f3a04f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Lazygit Config
- Git Branch Rules
- lazysql TUI SQL client
- Neovim LSP Env
- Lazydocker Config
- Bash Environment
- C# Semicolon Fixes
- Bash Prompt
- NET Workspace Detection
- Focus Dim
- Vscode Theme Overrides
- Dev Session Kill
- Git Config
- Bash RC Setup
- Blink Quote Transform
- Claude Statusline Usage
- Windows User Detection
- Claude Usage Bar
- Obsidian QA Logging
- Commit Message Generation
- Claude Statusline Script
- Tmux Split Script
- Zenhan IME Script
- Graphify Trigger Rule
- Mdkite Docs
- gui
- sqls-config.lua

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

## Communities (53 total, 37 thin omitted)

### Community 0 - "Lazygit Config"
Cohesion: 0.08
Nodes (25): cherryPickCopy, pasteCommits, renameCommit, squashDown, customCommands, command, context, description (+17 more)

### Community 1 - "Git Branch Rules"
Cohesion: 0.14
Nodes (14): bahori, feature/*, fix/*, main, theme, activeBorderColor, authorColors, branchColors (+6 more)

### Community 2 - "lazysql TUI SQL client"
Cohesion: 0.18
Nodes (11): Post-setup verification checklist, Managed config targets table, dev session kill (Q key), dotfiles repository overview, lazysql TUI SQL client, .lazysql.toml project connection file, Container-only TS/C# LSP policy, Podman rootless runtime (+3 more)

### Community 4 - "Neovim LSP Env"
Cohesion: 0.18
Nodes (13): entries_changed(), explorer_is_open(), has_solution_in_cwd(), keep_focus(), list_entries(), M.toggle(), M.use_solution_explorer(), same_entries() (+5 more)

### Community 5 - "Lazydocker Config"
Cohesion: 0.12
Nodes (15): gui, border, containerStatusHealthStyle, expandFocusedSidePanel, language, screenMode, scrollHeight, showBottomLine (+7 more)

### Community 6 - "Bash Environment"
Cohesion: 0.14
Nodes (13): BUILDKIT_PROGRESS, EDITOR, GIT_CONFIG_GLOBAL, LANG, LC_ALL, LESSHISTFILE, .bash_env.sh script, SQL_EDITOR (+5 more)

### Community 7 - "C# Semicolon Fixes"
Cohesion: 0.16
Nodes (3): has_vite_plus(), M.resolve_ox_tool(), vite_plus_bin()

### Community 8 - "Bash Prompt"
Cohesion: 0.15
Nodes (5): .bash_prompt script, GIT_PS1_SHOWDIRTYSTATE, GIT_PS1_SHOWSTASHSTATE, GIT_PS1_SHOWUNTRACKEDFILES, GIT_PS1_SHOWUPSTREAM

### Community 9 - "NET Workspace Detection"
Cohesion: 0.23
Nodes (8): glob_has_markers(), has_marker_under_container_workspace(), M.has_solution_root(), M.dotnet_lsp_available(), M.has_dotnet(), M.has_node(), M.in_container(), M.typescript_lsp_available()

### Community 10 - "Focus Dim"
Cohesion: 0.40
Nodes (10): apply_focus_state(), is_csharp_explorer_win(), is_nvim_tree_win(), set_all_winhighlights(), set_pane_hl(), set_tree_hl(), set_winhighlight(), sync_tree_buf() (+2 more)

### Community 12 - "Dev Session Kill"
Cohesion: 0.39
Nodes (6): collect_dead_pids(), pane_alive(), pid_alive_in_container(), read_swap_pid(), remove_swaps_matching_pids(), nvim-dev-session-kill.sh script

### Community 13 - "Git Config"
Cohesion: 0.29
Nodes (7): git, autoFetch, log, mainBranches, parseEmoji, order, showGraph

### Community 16 - "Blink Quote Transform"
Cohesion: 0.47
Nodes (3): M.single_to_double_quoted(), single_to_double_quoted(), transform_item()

### Community 17 - "Claude Statusline Usage"
Cohesion: 0.40
Nodes (4): Claude usage statusline, lazygit Claude commit message generation, symlink.sh deployment, symlink.sh script

### Community 18 - "Windows User Detection"
Cohesion: 0.50
Nodes (3): .bash_user.sh script, WIN_USER, WSL_USER

### Community 51 - "gui"
Cohesion: 0.18
Nodes (11): show, gui, border, commitLength, mouseEvents, nerdFontVersion, showCommandLog, showDivergenceFromBaseBranch (+3 more)

## Knowledge Gaps
- **26 isolated node(s):** `PODMAN_COMPOSE_PROVIDER`, `WIN_USER`, `WSL_USER`, `BUILDKIT_PROGRESS`, `EDITOR` (+21 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 180 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `gui` connect `gui` to `Lazygit Config`, `Git Branch Rules`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `PODMAN_COMPOSE_PROVIDER`, `WIN_USER`, `WSL_USER` to the rest of the system?**
  _26 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Lazygit Config` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._
- **Why does `theme` connect `Git Branch Rules` to `gui`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Should `Git Branch Rules` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `Clipboard OSC52` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._
- **Should `Lazydocker Config` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._