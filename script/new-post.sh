#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
POSTS_DIR="$REPO_ROOT/_posts"

if [ ! -d "$POSTS_DIR" ]; then
    printf 'Error: posts directory not found: %s\n' "$POSTS_DIR" >&2
    exit 1
fi

# Generate the filename and front matter timestamp from one clock reading.
STAMP=$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S +0800')
POST_DATE=${STAMP%% *}
TARGET="$POSTS_DIR/${POST_DATE}-draft.md"

TMP=$(mktemp "$POSTS_DIR/.new-post.XXXXXX")
cleanup() {
    rm -f "$TMP"
}
trap cleanup 0 1 2 3 15

cat > "$TMP" <<EOF
---
title: ""
date: $STAMP
description: ""
keywords: ""
typora-copy-images-to: ../images/$POST_DATE
---

## 文章内容

<!-- 在这里开始写作。 -->
EOF

# Linking the completed temporary file creates the target without overwriting
# an existing file, including when two commands run at the same time.
if ! ln "$TMP" "$TARGET" 2>/dev/null; then
    if [ -e "$TARGET" ]; then
        printf 'Error: post already exists: %s\n' "$TARGET" >&2
    else
        printf 'Error: could not create post: %s\n' "$TARGET" >&2
    fi
    exit 1
fi

printf 'Created: %s\n' "$TARGET"
