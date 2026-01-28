#!/usr/bin/env bash

audio_info=$(playerctl metadata --format "{{artist}} - {{title}}")

if [ -z "$audio_info" ]; then
    echo "Nothing playing"
else
    echo "$audio_info"
fi
