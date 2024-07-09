#!/bin/bash

COMPRESSED_TAG="CompressedByMozJPEG"

compress_image() {
  local original_img="$1"
  local temp_img="${original_img%.*}_temp.${original_img##*.}"
  
  if ! mozjpeg -quality 70 -outfile "$temp_img" "$original_img"; then
    echo "Error compressing $original_img. Skipping..."
    rm -f "$temp_img"
    return 1
  fi

  mv "$temp_img" "$original_img" && add_compressed_tag "$original_img"
}

add_compressed_tag() {
  local img="$1"
  exiftool -q -overwrite_original -Comment="$COMPRESSED_TAG" "$img";
}

is_already_compressed() {
  local img="$1"
  exiftool -Comment "$img" | grep -q "$COMPRESSED_TAG"
}

find_jpg_files() {
  local root_dir="${1:-.}"
  find "$root_dir" -type f -name '*.jpg' -print
}

process_images() {
  local jpg_files_tmp=$(mktemp)
  find_jpg_files > "$jpg_files_tmp"
  
  local total_files=$(wc -l < "$jpg_files_tmp")
  local not_compressed_files_tmp=$(mktemp)
  
  while read -r img; do
    if ! is_already_compressed "$img"; then
      echo "$img" >> "$not_compressed_files_tmp"
    fi
  done < "$jpg_files_tmp"
  
  local not_compressed_files=$(wc -l < "$not_compressed_files_tmp")

  echo "Total JPEG files found: $total_files"
  echo "JPEG files not compressed: $not_compressed_files"

  read -p "Do you want to compress the non-compressed JPEG files? (yes[y]/no[n]): " answer
  if [[ $answer != "y" ]]; then
    echo "Compression cancelled."
    rm "$jpg_files_tmp" "$not_compressed_files_tmp"
    return 0
  fi

  local processed_files=0

  while read -r img; do
    compress_image "$img" || echo "Failed to process $img."
    ((processed_files++))
    echo -ne "Processed $processed_files of $not_compressed_files files...\r"
  done < "$not_compressed_files_tmp"

  echo -ne "\nCompression complete!\n"
  rm "$jpg_files_tmp" "$not_compressed_files_tmp"
}

process_images