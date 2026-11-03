#!/usr/bin/env bash
set -euo pipefail

DIFF=$(git diff --cached)
if [ -z "$DIFF" ]; then
  gum style --foreground 196 "No staged changes"
  read -n 1 -s -r -p "Press any key to exit..."
  exit 1
fi

PROMPT="You are a commit message generator. Analyze the following git diff and generate one commit message conforming to Conventional Commits specification.


Write exactly one commit message in English.
- Subject line: 'type: concise description'.
- If the change needs a 'why' explanation, add one blank line and a short body.

Do NOT output markdown code blocks or any other text. Output ONLY the commit message.

Diff:
$DIFF"

# use temp file to avoid curl args error
TMP_PAYLOAD=$(mktemp)
echo "$PROMPT" > "$TMP_PAYLOAD"
TMP_RESPONSE=$(mktemp)
TMP_ERROR=$(mktemp)

# API request via Claude Code
gum spin --spinner dot --title "Generating git commit message. Please wait..." -- \
  bash -c "claude -p --model claude-haiku-5-5 --output-format text < $TMP_PAYLOAD > $TMP_RESPONSE 2>$TMP_ERROR"

MESSAGE=$(cat "$TMP_RESPONSE")
rm "$TMP_PAYLOAD" "$TMP_RESPONSE" "$TMP_ERROR"

# remove Markdown code fences if the model adds them anyway
MESSAGE=$(echo "$MESSAGE" | sed '/^```/d')

if [ -z "$MESSAGE" ]; then
  gum style --foreground 196 "Failed to generate commit message."
  read -n 1 -s -r -p "Press any key to exit..."
  exit 1
fi

# open the editor pre-filled with the message so the user can review before committing
FINAL_MSG=$(echo "$MESSAGE" | gum write --width 100 --height 10 --placeholder "Edit commit message...")

if [ -n "$FINAL_MSG" ]; then
  git commit -m "$FINAL_MSG"
else
  echo "Commit cancelled"
fi
