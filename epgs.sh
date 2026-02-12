#!/usr/bin/env bash

# SOURCES=(https://iptvx.one/EPG \
#             https://iptvx.one/EPG_LITE)

SOURCES=(https://iptvx.one/EPG_LITE)

for i in "${SOURCES[@]}"
do
    case ${#SOURCES[@]} in
        1)
            name=full.xml.gz
            ;;
        *)
            name=$(basename "$i").xml.gz
            ;;
    esac
    curl -sL "$i" -o "$name"
done
