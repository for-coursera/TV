#!/usr/bin/env bash

REP=$(git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/')

TAG=$(curl -sH "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/${REP}/tags | \
    jq -r '.[].name' | \
    awk '{
        print $1, strftime("%c", gensub(/[^-]*-(.*)/, "\\1", 1))
    }' | \
    fzf --reverse --cycle | \
    awk '{print $1}')

[ -n "${TAG}" ] && \
    curl -sLO https://github.com/${REP}/releases/download/${TAG}/full.xml.gz
