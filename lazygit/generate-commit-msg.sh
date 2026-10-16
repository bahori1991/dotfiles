#!/usr/bin/env bash
set -euo pipefail

DIFF=$(git diff --cached)
if [ -z "$DIFF" ]; then
  gum style --foreground 196 "No staged changes"
  read -n 1 -s -r -p "Press any key to exit..."
  exit 1
fi

PROMPT="You are a commit message generator. Analyze the following git diff and generate 4 distinct commit messages conforming to Conventional Commits specification.


Generate the following 4 variations:
1. English: A standard, concise message.
2. English: A slightly more detailed message explaining the 'why'.
3. Japanese: A standard, concise message (日本語).
4. Japanese: A slightly more detailed message (日本語).

Output MUST be a valid JSON array of strings, like:
[\"feat: english message\", \"fix: english detailed...\\n\\nbody\", \"feat: 日本語のメッセージ\", \"fix: 日本語の詳細...\\n\\n本文...\"]

Formatting rules:
- Variations 1 and 3 (concise): subject line only.
- Variations 2 and 4 (detailed): subject line, then one blank line, then the body.
- Put line breaks inside each string as \\n escapes so each message stays one JSON string.

Do NOT output markdown code blocks. Output ONLY the JSON array.

Diff:
$DIFF"

# use temp file to avoid curl args error
TMP_PAYLOAD=$(mktemp)
echo "$PROMPT" > "$TMP_PAYLOAD"
TMP_RESPONSE=$(mktemp)
TMP_ERROR=$(mktemp)

# API request via Claude Code
gum spin --spinner dot --title "Generating candidates..." -- \
  bash -c "claude -p --model claude-haiku-5-5 --output-format text < $TMP_PAYLOAD > $TMP_RESPONSE 2>$TMP_ERROR"

CANDIDATES=$(cat "$TMP_RESPONSE")
rm "$TMP_PAYLOAD" "$TMP_RESPONSE" "$TMP_ERROR"

# remove Markdown code blocks
CANDIDATES_CLEAN=$(echo "$CANDIDATES" | sed 's/^```json//g' | sed 's/^```//g')

# show only the subject line of each candidate in the picker
CHOICES=$(echo "$CANDIDATES_CLEAN" | jq -r '.[] | split("\n")[0]' 2>/dev/null)

if [ -z "$CHOICES" ]; then
  gum style --foreground 196 "Failed to parse candidates."
  echo "Raw Response: $CANDIDATES"
  read -n 1 -s -r -p "Press any key to exit..."
  exit 1
fi

# select choices
SELECTED_MSG=$(echo "$CHOICES" | gum choose --header "Pick a commit message (English/Japanese)")

if [ -z "$SELECTED_MSG" ]; then
  echo "Canceled"
  exit 0
fi

# restore the full candidate (subject + body) that matches the selected subject
FULL_MSG=$(echo "$CANDIDATES_CLEAN" | jq -r --arg s "$SELECTED_MSG" 'first(.[] | select(split("\n")[0] == $s))')

# open and editor pre-filled with the selected candidate
FINAL_MSG=$(echo "$FULL_MSG" | gum write --width 100 --height 10 --placeholder "Edit commit message...")

if [ -n "$FINAL_MSG" ]; then
  git commit -m "$FINAL_MSG"
  clear
else
  echo "Commit cancelled"
fi

