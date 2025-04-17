#!/bin/bash

# Usage: ./sort_packages.sh file.tex

file="$1"
temp_raw="__use_raw.tmp"
temp_sorted="__use_sorted.tmp"
temp_rest="__rest.tmp"

# 1. Extract all \usepackage lines, including commented ones
grep -E '^[[:space:]]*%?[[:space:]]*\\usepackage(\[[^]]*\])?\{[^}]+\}' "$file" > "$temp_raw"

# 2. Extract package name between { } and sort based on that
awk '
{
  line = $0
  # Find first "{" and first "}" after it
  brace_start = index(line, "{")
  brace_end = index(line, "}")
  if (brace_start > 0 && brace_end > brace_start) {
    key = substr(line, brace_start + 1, brace_end - brace_start - 1)
    print key "\t" line
  }
}' "$temp_raw" | sort -k1,1 | cut -f2- > "$temp_sorted"

# 3. Remove original \usepackage lines from the file
grep -v -E '^[[:space:]]*%?[[:space:]]*\\usepackage(\[[^]]*\])?\{[^}]+\}' "$file" > "$temp_rest"

# 4. Reconstruct the file: sorted usepackages at the top, then the rest
{
  cat "$temp_sorted"
  echo ""
  cat "$temp_rest"
} > "$file"

# 5. Clean up
rm -f "$temp_raw" "$temp_sorted" "$temp_rest"

echo "✅ Sorted \\usepackage{} lines (including commented ones) in $file."

