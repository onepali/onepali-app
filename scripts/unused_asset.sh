#!/bin/bash

echo "Checking for unused assets..."
echo "================================"

# Find all asset files and check for usage
find assets -type f -name "*" | while read -r asset_path; do
    asset_name=$(basename "$asset_path")
    asset_name_no_ext="${asset_name%.*}"
    
    # Check if asset is used in the Assets class or anywhere in the codebase
    found=false
    
    # Search for the base name (without extension) since your Assets class uses extensions
    if grep -r -q "'$asset_name_no_ext'" lib/ 2>/dev/null; then
        found=true
    # Also check for the full filename
    elif grep -r -q "'$asset_name'" lib/ 2>/dev/null; then
        found=true
    # Check for the asset path
    elif grep -r -q "$asset_path" lib/ 2>/dev/null; then
        found=true
    # Check without quotes (in case it's used differently)
    elif grep -r -q "$asset_name_no_ext" lib/ 2>/dev/null; then
        found=true
    fi
    
    if [ "$found" = false ]; then
        echo "Unused asset: $asset_path"
    fi
done

echo "================================"
echo "Done!"