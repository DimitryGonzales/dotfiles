#!/usr/bin/env bash

AUDIO_INFO=$(playerctl metadata --format "{{artist}} - {{title}}")

if [ -z "$AUDIO_INFO" ]; then
    echo "Nothing playing..."
else
    echo "$AUDIO_INFO"
fi
