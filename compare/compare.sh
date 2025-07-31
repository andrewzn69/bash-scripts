#!/bin/bash

function file_exists() {
	local file="$1"
	[[ -f "$file" ]]
}

folder1="$1"
folder2="$2"

if [[ -z "$folder1" || -z "$folder2" ]]; then
	echo "Error: Please provide two folder paths."
	exit 1
fi

if ! [[ -d "$folder1" || -d "$folder2" ]]; then
	echo "Error: One or both folders do not exist."
	exit 1
fi

output_file="missing_files.txt"

rm -f "$output_file"

find "$folder2" -type f -print0 | while IFS= read -r -d '' file; do
	filename=$(basename "$file")
	if ! file_exists "$folder1/$filename"; then
		echo "$filename" >> "$output_file"
	fi
done

if [[ -s "$output_file" ]]; then
	echo "Missing files list saved to: $output_file"
else
	echo "No missing files found in $folder1 compared to $folder2"
fi
