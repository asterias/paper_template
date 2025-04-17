#!/bin/bash

# Usage: ./merge_usepackage.sh file1.tex file2.tex

file1="$1"
file2="$2"
temp_union="__usepackage_union.tmp"

# Match any line that includes \usepackage, even if it's commented out
{
  grep -E '^\s*%?\s*\\usepackage' "$file1"
  grep -E '^\s*%?\s*\\usepackage' "$file2"
} | sort -u > "$temp_union"

# Remove all lines containing \usepackage from both files
file1_cleaned="__${file1}.clean"
file2_cleaned="__${file2}.clean"

grep -v -E '^\s*%?\s*\\usepackage' "$file1" > "$file1_cleaned"
grep -v -E '^\s*%?\s*\\usepackage' "$file2" > "$file2_cleaned"

# Rebuild file1: union of usepackage lines at the top + the rest of file1
{
  cat "$temp_union"
  echo ""
  cat "$file1_cleaned"
} > "$file1"

# Replace file2 with cleaned version
mv "$file2_cleaned" "$file2"

# Cleanup
rm "$file1_cleaned" "$temp_union"

echo "✅ Done. All \\usepackage lines (including commented ones) merged into $file1 and removed from $file2."

