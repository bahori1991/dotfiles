# Graph Report - dotfiles  (2026-11-03)

## Corpus Check
- Corpus is ~14,075 words - fits in a single context window. You may not need a graph.

## Summary
- 292 nodes · 301 edges · 52 communities (16 shown, 36 thin omitted)
- Extraction: 98% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.6)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Lazygit Config
- Lazygit Git Branch Settings
- Clipboard Integration
- Explorer Panel
- Lazydocker Config
- DotNet Workspace Detection
- Bash Environment
- Lint and Semicolon Fixes
- Bash Prompt
- SQL LSP Config
- Focus Dim Highlights
- Lualine Theme
- Dev Session Kill Script
- Lazygit Git Options
- Bash Startup
- Blink Completion Transform
- Project Policy and Docs
- Windows User Config
- Claude Usage Display
- Container LSP Policy
- Obsidian QA Logging
- Commit Message Generation
- Claude Statusline
- Symlink Deployment
- Tmux Split
- IME Off Script
- REST Client Plugin

## God Nodes (most connected - your core abstractions)
1. `gui` - 11 edges
2. `gui` - 11 edges
3. `theme` - 10 edges
4. `universal` - 9 edges
5. `sync_winhighlights()` - 7 edges
6. `customCommands` - 6 edges
7. `theme` - 5 edges
8. `git` - 5 edges
9. `commits` - 5 edges
10. `parse_postgres_url()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Implementation owned by user policy` --conceptually_related_to--> `lazygit Claude commit message generation`  [AMBIGUOUS]
  .claude/CLAUDE.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Container-based LSP and tooling** — readme_lsp_container_policy, readme_podman_rootless, readme_sqls_lsp [INFERRED 0.75]

## Communities (52 total, 36 thin omitted)

### Community 0 - "Lazygit Config"
Cohesion: 0.08
Nodes (25): cherryPickCopy, pasteCommits, renameCommit, squashDown, customCommands, command, context, description (+17 more)

### Community 1 - "Lazygit Git Branch Settings"
Cohesion: 0.08
Nodes (25): bahori, feature/*, fix/*, main, show, gui, border, commitLength (+17 more)

### Community 2 - "Clipboard Integration"
Cohesion: 0.10
Nodes (3): M.setup_directory(), swap_container_segment(), swap_dir()

### Community 3 - "Explorer Panel"
Cohesion: 0.19
Nodes (13): entries_changed(), explorer_is_open(), has_solution_in_cwd(), keep_focus(), list_entries(), M.toggle(), M.use_solution_explorer(), same_entries() (+5 more)

### Community 4 - "Lazydocker Config"
Cohesion: 0.12
Nodes (15): gui, border, containerStatusHealthStyle, expandFocusedSidePanel, language, screenMode, scrollHeight, showBottomLine (+7 more)

### Community 5 - "DotNet Workspace Detection"
Cohesion: 0.19
Nodes (8): glob_has_markers(), has_marker_under_container_workspace(), M.has_solution_root(), M.dotnet_lsp_available(), M.has_dotnet(), M.has_node(), M.in_container(), M.typescript_lsp_available()

### Community 6 - "Bash Environment"
Cohesion: 0.14
Nodes (13): BUILDKIT_PROGRESS, EDITOR, GIT_CONFIG_GLOBAL, LANG, LC_ALL, LESSHISTFILE, .bash_env.sh script, SQL_EDITOR (+5 more)

### Community 7 - "Lint and Semicolon Fixes"
Cohesion: 0.16
Nodes (3): has_vite_plus(), M.resolve_ox_tool(), vite_plus_bin()

### Community 8 - "Bash Prompt"
Cohesion: 0.15
Nodes (5): .bash_prompt script, GIT_PS1_SHOWDIRTYSTATE, GIT_PS1_SHOWSTASHSTATE, GIT_PS1_SHOWUNTRACKEDFILES, GIT_PS1_SHOWUPSTREAM

### Community 9 - "SQL LSP Config"
Cohesion: 0.27
Nodes (10): expand_env_in_url(), find_lazysql_toml(), first_postgres_url_in_lazysql(), M.connections_for_root(), parse_postgres_url(), parse_sslmode_from_query(), trim_line(), url_decode() (+2 more)

### Community 10 - "Focus Dim Highlights"
Cohesion: 0.40
Nodes (10): apply_focus_state(), is_csharp_explorer_win(), is_nvim_tree_win(), set_all_winhighlights(), set_pane_hl(), set_tree_hl(), set_winhighlight(), sync_tree_buf() (+2 more)

### Community 12 - "Dev Session Kill Script"
Cohesion: 0.39
Nodes (6): collect_dead_pids(), pane_alive(), pid_alive_in_container(), read_swap_pid(), remove_swaps_matching_pids(), nvim-dev-session-kill.sh script

### Community 13 - "Lazygit Git Options"
Cohesion: 0.29
Nodes (7): git, autoFetch, log, mainBranches, parseEmoji, order, showGraph

### Community 16 - "Blink Completion Transform"
Cohesion: 0.47
Nodes (3): M.single_to_double_quoted(), single_to_double_quoted(), transform_item()

### Community 17 - "Project Policy and Docs"
Cohesion: 0.40
Nodes (3): Claude usage statusline, lazygit Claude commit message generation, symlink.sh deployment

### Community 18 - "Windows User Config"
Cohesion: 0.50
Nodes (3): .bash_user.sh script, WIN_USER, WSL_USER

## Ambiguous Edges - Review These
- `lazygit Claude commit message generation` → `Implementation owned by user policy`  [AMBIGUOUS]
  .claude/CLAUDE.md · relation: conceptually_related_to

## Knowledge Gaps
- **23 isolated node(s):** `SQL_EDITOR`, `EDITOR`, `VISUAL`, `LANG`, `LC_ALL` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 177 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `gui` connect `Lazygit Git Branch Settings` to `Lazygit Config`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **What connects `SQL_EDITOR`, `EDITOR`, `VISUAL` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Lazygit Config` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._
- **Should `Lazygit Git Branch Settings` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._
- **Should `Clipboard Integration` be split into smaller, more focused modules?**
  _Cohesion score 0.09956709956709957 - nodes in this community are weakly interconnected._
- **Should `Lazydocker Config` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `lazygit Claude commit message generation` and `Implementation owned by user policy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._