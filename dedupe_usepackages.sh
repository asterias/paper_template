#!/bin/bash

# Usage: ./dedupe_usepackages.sh input.tex

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "Input file not found!"
    exit 1
fi

# Create temporary file
TMP_FILE=$(mktemp)

awk '
{
    # Match lines like \usepackage{...} or %\usepackage{...}
    if ($0 ~ /^[ \t]*%?[ \t]*\\usepackage[ \t]*\{[^\}]+\}/) {
        line = $0
        pkg_line = line
        sub(/^.*\\usepackage[ \t]*\{/, "", pkg_line)
        sub(/\}.*/, "", pkg_line)
        if (!(pkg_line in seen)) {
            seen[pkg_line] = 1
            print $0
        }
    } else {
        print $0
    }
}
' "$INPUT" > "$TMP_FILE"

# Replace original file
mv "$TMP_FILE" "$INPUT"

echo "✅ Duplicates removed directly in '$INPUT'."

