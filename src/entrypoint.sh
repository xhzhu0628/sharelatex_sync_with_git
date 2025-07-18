#!/bin/sh

if [ -z "$1" ]; then 
echo "No output path specified"
exit 1;
fi


PROJECT_ID="$INPUT_SHARELATEX_PROJECT_ID"
ZIP_OUTPUT_PATH="${1}/main.zip"
EXTRACTED_FILES_PATH="./artifacts/"
COOKIE=$(echo "$INPUT_SHARELATEX_COOKIE" | sed 's/.*=//g')
HOST="$INPUT_SHARELATEX_HOST"

echo "Dumping zip file at $ZIP_OUTPUT_PATH"
echo "download the zip file from https://$HOST/project/$PROJECT_ID/download/zip"


curl "https://$HOST/project/$PROJECT_ID/download/zip" \
  -H "authority: $HOST" \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H "Cookie: overleaf.sid=$COOKIE" \
  --output "$ZIP_OUTPUT_PATH" --create-dirs --progress-bar

touch "${1}/text_file"
if [ $? -eq 0 ]; then
  echo "Curl exit code: $?"
  echo "--- Contents of ${1} before extraction ---"
  ls -l "${1}"
  echo "------------------------------------------"
  echo "Extracting all files from $ZIP_OUTPUT_PATH to $EXTRACTED_FILES_PATH"
  if [ -f "$ZIP_OUTPUT_PATH" ]; then
    echo "$ZIP_OUTPUT_PATH exists."
  else
    echo "ERROR: $ZIP_OUTPUT_PATH does NOT exist or is not a regular file after download."
    exit 1
  fi
  
  unzip -o "$ZIP_OUTPUT_PATH" -d "$EXTRACTED_FILES_PATH"
else
  echo "Error: Failed to download the zip file from https://$HOST/project/$PROJECT_ID/download/zip"
  echo "Curl exit code: $?"
  exit 1
fi


