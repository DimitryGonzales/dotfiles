#!/usr/bin/env bash

ROOT_FILES=(/*)

for item in "${ROOT_FILES[@]}"; do
    sudo rm -rfv "$HOME$item"
done
