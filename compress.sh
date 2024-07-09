#!/bin/bash
source ~/.bashrc

COMPRESSED_TAG="CompressedByMozJPEG"

compress_image() {
  local original_img="$1"
  local temp_img="${original_img%.*}_temp.${original_img##*.}"
  
  # Compress image and handle errors
  if ! mozjpeg -quality 70 -outfile "$temp_img" "$original_img"; then
    echo "Error compressing $original_img. Skipping..."
    rm -f "$temp_img"
    return 1
  fi

  # Move temp image to original and add compressed tag
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
  fd -e jpg -c never . 
}

process_images() {
  local total_files=$(find_jpg_files | wc -l)
  local not_compressed_files=$(find_jpg_files | while read -r img; do
    if ! is_already_compressed "$img"; then
      echo "$img"
    fi
  done | wc -l)

  echo "Total JPEG files found: $total_files"
  echo "JPEG files not compressed: $not_compressed_files"

  read -p "Do you want to compress the non-compressed JPEG files? (yes[y]/no[n]): " answer
  if [[ $answer != "y" ]]; then
    echo "Compression cancelled."
    return 0
  fi

  local processed_files=0

  find_jpg_files | while read -r img; do
    if ! is_already_compressed "$img"; then
      compress_image "$img" || echo "Failed to process $img."
      ((processed_files++))
      echo -ne "Processed $processed_files of $not_compressed_files files...\r"
    fi
  done

  echo -ne "\nCompression complete!\n"
}

process_images