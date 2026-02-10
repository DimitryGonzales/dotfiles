#!/usr/bin/env bash

AUDIO_INFO=$(playerctl metadata --format "{{artist}} - {{title}}")

if [ -n "$AUDIO_INFO" ]; then
    echo "$AUDIO_INFO"
else
    echo "Nothing playing..."
fi
