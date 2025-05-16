#!/bin/bash

file_contents="$1"
file_name="$2"

printf "%b" "$file_contents" > "$file_name"
