#!/usr/bin/env bash

echo $UNDEFINED_VAR
if [[ $1 = "test" ]]; then
	echo "Test mode"
fi
