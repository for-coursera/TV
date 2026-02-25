#!/usr/bin/env bash

DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
cd "$DIR" || exit
REP=$(git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/')
cd - > /dev/null || exit

TAG=$(curl -sH "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/"${REP}"/tags | \
    jq -r '.[].name' | \
    awk '{
        print $1, strftime("%c", gensub(/[^-]*-(.*)/, "\\1", 1))
    }' | \
    fzf --reverse --cycle | \
    awk '{print $1}')

[ -n "${TAG}" ] && \
    FILES=($(curl -sL https://api.github.com/repos/"${REP}"/releases/tags/"${TAG}" | jq -r .assets[].browser_download_url))

[ ${#FILES[@]} -gt 0 ] && \
    for file in "${FILES[@]}"
    do
        curl -sLO "$file"
    done
