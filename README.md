# download-album-from-youtube
Usage: `./download_album_from_youtube.sh <YT url>`

You have to create a file named `timestamps.txt` which must
contain, for each song in the YT video, the following data:
`<timestamp song start> <timestamp song end> <song title>`

IMPORTANT, each timestamp MUST follow this format:
`HH:MM:SS`

In order to fill in the ID3 tags, this program will ask for album
info such as its title, the artist who produced the album and the
year of publication. You can provide these info by passing them as
environment variables.

The variables are:
`ALBUM_ARTIST`
`ALBUM_TITLE`
`ALBUM_YEAR`
