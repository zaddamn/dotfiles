#!/bin/bash
FEEDS="$HOME/.config/hypr/deckhand-feeds.txt"
STILL="$HOME/Pictures/Wallpapers/still.png"
VIDEO_OPTS="loop-file=inf ytdl-format=bestvideo[height<=1080]+bestaudio/best[height<=1080]/best volume=100 input-ipc-server=/tmp/mpvsocket"
STILL_OPTS="image-display-duration=inf loop-file=inf input-ipc-server=/tmp/mpvsocket"

start() {
    pkill mpvpaper
    sleep 0.5
    setsid -f mpvpaper '*' -o "$1" "$2"
}

CHOICE=$({ echo "still"; cut -d'|' -f1 "$FEEDS"; echo "+ add new feed"; echo "- delete a feed"; } | wofi --dmenu --prompt "Deckhand: pick a feed, or paste a link")

[ -z "$CHOICE" ] && exit 0

if [ "$CHOICE" = "still" ]; then
    start "$STILL_OPTS" "$STILL"
elif [ "$CHOICE" = "+ add new feed" ]; then
    NAME=$(echo "" | wofi --dmenu --prompt "Feed Name:")
    NAME=${NAME//|/}
    [ -z "$NAME" ] || [ "$NAME" = "Feed Name:" ] && exit 0
    URL=$(echo "" | wofi --dmenu --prompt "Link:")
    [ -z "$URL" ] || [ "$URL" = "Link:" ] && exit 0
    echo "$NAME|$URL" >> "$FEEDS"
    start "$VIDEO_OPTS" "$URL"
elif [ "$CHOICE" = "- delete a feed" ]; then
    DEL=$(cut -d'|' -f1 "$FEEDS" | wofi --dmenu --prompt "Delete which feed? (Esc to cancel)")
    [ -z "$DEL" ] && exit 0
    awk -F'|' -v n="$DEL" '$1!=n' "$FEEDS" > /tmp/deckhand-feeds.tmp
    cat /tmp/deckhand-feeds.tmp > "$FEEDS"
    rm -f /tmp/deckhand-feeds.tmp
elif [[ "$CHOICE" == http* ]]; then
    start "$VIDEO_OPTS" "$CHOICE"
else
    URL=$(awk -F'|' -v n="$CHOICE" '$1==n {print $2; exit}' "$FEEDS")
    [ -z "$URL" ] || [ "$URL" = "Link:" ] && exit 0
    start "$VIDEO_OPTS" "$URL"
fi
