#!/bin/bash

function print_list {
    title="$1"
    messages="$2"

    if [ -z "$messages" ]; then
        return
    fi

    echo -e "# $title\n"

    IFS=$'\n'
    for line in $messages; do
        echo "$line"
    done

    echo
}

# Check if there are any tags
tag_count=$(git tag | wc -l)

if [ "$tag_count" -eq 0 ]; then
    echo "# First Release"
    echo ""
    echo "This is the first release of the application."
    echo ""
    echo "## All Changes"
    git log --format='- %s' | head -20
    exit 0
fi

prev_ver=$(git tag --sort=-creatordate | head -2 | tail -1)
current_ver=$(git tag --sort=-creatordate | head -1)

if [ "$prev_ver" == "$current_ver" ] || [ -z "$prev_ver" ]; then
    echo "# Latest Changes"
    echo ""
    echo "## Recent Commits"
    git log --format='- %s' | head -10
    exit 0
fi

commits=$(git log $prev_ver..$current_ver --format='- %s' | grep -v 'release:') 

echo -e "**Changes from the last release:** https://github.com/onepali/onepali-app/compare/$prev_ver...$current_ver\n"

print_list 'Breaking changes' "$(grep '!:' <<< $commits)"
print_list 'Features' "$(grep 'feat:' <<< $commits)"
print_list 'Fixes' "$(grep 'fix:' <<< $commits)"
print_list 'Other' "$(grep -Ev '!:|feat:|fix:' <<< $commits)"