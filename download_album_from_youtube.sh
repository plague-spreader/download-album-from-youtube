#!/bin/bash

usage() {
    echo "Usage: $0 <YT url>"
    echo
    echo "You have to create a file named \"timestamps.txt\" which must"
    echo "contain, for each song in the YT video, the following data:"
    echo "<timestamp song start> <timestamp song end> <song title>"
    echo
    echo "IMPORTANT, each timestamp MUST follow this format:"
    echo "HH:MM:SS"
    echo
    echo "In order to fill in the ID3 tags, this program will ask for album"
    echo "info such as its title, the artist who produced the album and the"
    echo "year of publication. You can provide these info by passing them as"
    echo "environment variables."
    echo
    echo "The variables are:"
    echo "ALBUM_ARTIST"
    echo "ALBUM_TITLE"
    echo "ALBUM_YEAR"
}

ask_for_info() {
    for var in $@; do
        if [ "${!var}" ]; then
            echo "Variable \"${var}\" set to \"${!var}\""
        else
            read -p "${var}: " $var
        fi
    done
}

[ $# -ge 1 ] || {
    >&2 echo "No URL (1st argument) provided"
    >&2 usage
    exit 1
}

[ -f timestamps.txt ] || {
    >&2 echo "\"timestamps.txt\" not found"
    >&2 usage
    exit 1
}

ask_for_info ALBUM_ARTIST ALBUM_TITLE ALBUM_YEAR
ALBUM_NUM_SONGS=$(wc -l timestamps.txt | cut -d\  -f1)

yt-dlp -x --audio-format mp3 "$1" -o tmp
i=1
while read line; do
    echo -e "Parsing \"$line\""
    echo
    start=${line:0:8}
    end=${line:9:8}
    title=${line:18}
    filename=$(printf "%02d - $title.mp3" $i)
    ffmpeg -i tmp.mp3 -ss $start -to $end -c copy "$filename"
    id3tag -a"${ALBUM_ARTIST}" -A"${ALBUM_TITLE}" -s"$title" -y"${ALBUM_YEAR}"\
        -t"$i" -T"${ALBUM_NUM_SONGS}" "$filename"
    let i++
done < timestamps.txt

echo
echo "You can remove the \"timestamps.txt\" and \"tmp.mp3\" files now"
