#!/bin/bash
# Claude code Stop hook: add recent Q&A to Obsidian daily-notes.

VAULT="/mnt/c/Users/bahori1991/bahori-Obsidian"
FOLDER="Claude-Code"

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

RESULT=$(jq -s -c '
  def text:
    if type == "string" then .
    elif type == "array" then [.[] | select(.type == "text") | .text] | join("\n")
    else "" end;
  . as $all
  | ([range(0; length) as $i
    | select($all[$i].type == "user"
        and ($all[$i].isMeta | not)
        and ($all[$i].message.content | text | length > 0))
    | $i] | last) as $u
  | if $u == null then empty
    else {
      prompt: ($all[$u].message.content | text | gsub("^\\s+|\\s+$"; "")),
      answer: ([$all[$u+1:][]
              | select(.type == "assistant")
              | .message.content | text | select(length > 0)]
            | join("\n\n"))
    } end
' "$TRANSCRIPT" 2>/dev/null)

[ -z "$RESULT" ] && exit 0

PROMPT=$(echo "$RESULT" | jq -r ".prompt")
ANSWER=$(echo "$RESULT" | jq -r ".answer")

NOTE="$VAULT/$FOLDER/$(date +%Y-%m-%d).md"
mkdir -p "$(dirname "$NOTE")"

{
  printf '## %s\n\n' "$(date +%H:%M)"
  printf '### Q\n%s\n\n' "$PROMPT"
  printf '### A\n%s\n\n' "${ANSWER:-(no answer)}"
  printf -- '---\n\n'
} >> "$NOTE"

exit 0
