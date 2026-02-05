if pgrep "steam" > /dev/null; then
    steam -shutdown > /dev/null
fi

while true; do
    if ! pgrep "steam" > /dev/null; then
        nohup steam & disown
        break
    fi
done
