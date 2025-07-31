#!/bin/bash

current_dir="$1"
cd "$current_dir" || exit

mkdir -p sorted

SOURCE="$current_dir"
DESTINATION="sorted"
get_destination() {
	case "${1##*.}" in
	jpg | JPG | jpeg | JPEG | png | PNG | gif | GIF | bmp | BMP | svg | SVG) echo "images" ;;
	pdf | PDF | doc | DOC | docx | DOCX | rtf | RTF | txt | TXT | odt | ODT | pages | PAGES) echo "documents" ;;
	mp4 | MP4 | mkv | MKV | avi | AVI | mov | MOV | wmv | WMV | flv | FLV | webm | WEBM) echo "videos" ;;
	mp3 | MP3 | wav | WAV | flac | FLAC | aac | AAC | ogg | OGG) echo "audio" ;;
	zip | ZIP | rar | RAR | 7z | 7Z | iso | ISO | dmg | DMG) echo "archives" ;;
	py | PY | java | JAVA | cpp | CPP | cs | CS | php | PHP | rb | RB | go | GO) echo "code" ;;
	*) echo "misc" ;;
	esac
}

find "${SOURCE}" -type f -exec bash -c '
    for FILE do
        DEST=$(get_destination "$FILE")
        mkdir -p "${2}/${DEST}"
        rsync -azh --progress --stats --ignore-existing "$FILE" "${2}/${DEST}/"
    done
' bash {} "${DESTINATION}" \+

rsync -azh --progress --stats "${DESTINATION}/" "${SOURCE}/${DESTINATION}"
