#!/bin/bash

current_dir="$1"
cd "$current_dir" || exit

read -rp "Enter the URL: " url

scrape() {
	wget \
		--recursive \
		--no-clobber \
		--page-requisites \
		--adjust-extension \
		--span-hosts \
		--convert-links \
		--restrict-file-names=windows \
		--domains "$url" \
		--no-parent -e robots=off \
		--retry-connrefused \
		--waitretry=1 \
		--read-timeout=20 \
		--timeout=15 \
		-t 0 \
		--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36" \
		--header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
		--header="Accept-Language: en-US,en;q=0.5" \
		"$url"
}

echo "Downloading $url..."
scrape
