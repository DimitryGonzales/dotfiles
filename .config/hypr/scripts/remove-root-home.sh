#!/usr/bin/env bash

root_files=(/*)

for item in "${root_files[@]}"; do
    sudo rm -rfv "$HOME$item"
done
