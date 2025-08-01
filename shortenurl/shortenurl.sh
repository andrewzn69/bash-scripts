#!/bin/bash

shorten_url() {
	local url="$1"
	local shortened

	shortened=$(curl -s "https://is.gd/create.php?format=simple&url=$(printf '%s' "$url" | sed 's/ /%20/g')")

	if [[ $shortened == http* ]]; then
		echo "$shortened"
	else
		echo "Error: $shortened" >&2
		return 1
	fi
}

show_help() {
	echo "Usage: $0 [URL] [-f FILE]"
	echo "  URL     Single URL to shorten"
	echo "  -f FILE Text file with URLs (one per line)"
	echo ""
	echo "Examples:"
	echo "  $0 https://example.com"
	echo "  $0 -f urls.txt"
}

if [[ $# -eq 0 ]]; then
	show_help
	exit 1
fi

if [[ "$1" == "-f" ]]; then
	# process file with multiple urls
	if [[ -z "$2" ]]; then
		echo "Error: No file specified" >&2
		exit 1
	fi

	if [[ ! -f "$2" ]]; then
		echo "Error: File '$2' not found" >&2
		exit 1
	fi

	while IFS= read -r line; do
		if [[ -n "$line" ]]; then
			shortened=$(shorten_url "$line")
			echo "$line -> $shortened"
		fi
	done < "$2"

elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	show_help
	exit 0

else
	# process single url
	shorten_url "$1"
fi
