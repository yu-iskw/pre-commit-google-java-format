#!/usr/bin/env sh

set -e
set -o errexit
set -o nounset

# Create a directory to cache the downloaded jar
cache_directory=".pre-commit"
mkdir -p "$cache_directory"

# Download google-java-format jar
current_dir="$(pwd)"
cd "$cache_directory" || exit
url="https://github.com/google/google-java-format/releases/download/google-java-format-1.7/google-java-format-1.7-all-deps.jar"
jar_file="${url##*/}"
if [ ! -f $jar_file ] ; then
    curl -LJO "$url"
fi
cd "$current_dir" || exit

# Make a list of changed files in git staging.
changed_java_files=$(git diff --cached --name-only --diff-filter=ACMR | grep ".*java$")

# Show the list.
echo "$changed_java_files"

# Format java code.
# shellcheck disable=SC2086
java -jar "${cache_directory}/${jar_file}" --replace $changed_java_files
