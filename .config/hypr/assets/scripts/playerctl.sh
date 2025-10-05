#!/usr/bin/env bash

audio_info=$(playerctl metadata --format "{{artist}} - {{title}}")

echo "$audio_info"
