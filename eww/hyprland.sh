#!/usr/bin/env bash

NUMBER_OF_WORKSPACES=10

window_class() {
	hyprctl activewindow -j | jq --raw-output .class
}

window_title() {
	hyprctl activewindow -j | jq --raw-output .title
}

workspaces() {
	# get workspace windows data
	WORKSPACE_WINDOWS=$(hyprctl workspaces -j | jq 'map({key: .id | tostring, value: .windows}) | from_entries')
	# generate sequence and match with workspace windows
	seq 1 $NUMBER_OF_WORKSPACES | jq --argjson windows "${WORKSPACE_WINDOWS}" --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})'
}

if [[ $1 == 'workspaces' ]]; then
	echo "{ \"workspaces\": $(workspaces), \"active\": 1, \"active_empty\": true }"
	socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r line; do
		# update active workspace if focused monitor or workspace changes
		if [[ $line =~ "focusedmon" || $line =~ "workspace" ]]; then
			active=$(hyprctl activeworkspace | awk '/workspace ID/ {print $3}')
		fi

		# check if active workspace is empty
		active_empty='true'
		((i = active - 1))
		if [[ $(workspaces | jq --raw-output .[$i].windows) -gt 0 ]]; then active_empty='false'; fi

		# update workspaces and dock reveal status
		eww update workspaces="{
            \"workspaces\": $(workspaces),
            \"active\": $active,
            \"active_empty\": $active_empty
        }"

		eww update dock_reveal="$active_empty"
	done
fi

if [[ $1 == 'window' ]]; then
	window_class
	socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r line; do
		window_class
	done
fi
