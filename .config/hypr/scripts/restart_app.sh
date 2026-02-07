#!/usr/bin/env bash

if ! command -v "$1" > /dev/null; then
    printf "App '%s' not found." "$1" >&2
    exit 1
fi

if pgrep "$1" > /dev/null; then
    pkill "$1"

    while true; do
        if ! pgrep "$1" > /dev/null; then
            nohup $1 > /dev/null 2>&1 & disown
            break
        fi
    done
fi
