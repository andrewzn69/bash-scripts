#!/bin/bash

# get current directory
current_directory="$(pwd)"

for file in "$current_directory"/*.mkv "$current_directory"/*.mp4 "$current_directory"/*.m4a; do
	if [ -f "$file" ]; then
		# extract episode name and number
		if [[ $file =~ ([A-Za-z_.]+)_S?([0-9]+)E([0-9]+)_.*\.(mkv|mp4|m4a) ]]; then
			series_name="${BASH_REMATCH[1]}"
			season_number="${BASH_REMATCH[2]}"
			episode_number="${BASH_REMATCH[3]}"
			extension="${BASH_REMATCH[4]}"

			# e.g. Chernobyl S01E05.mkv
			new_filename="${series_name//./ } S${season_number}E${episode_number}.${extension}"

			mv "$file" "$current_directory/$new_filename"
			echo "Renamed: $file -> $current_directory/$new_filename"
		else
			echo "Skipping: $file (File format not recognized)"
		fi
	fi
done
