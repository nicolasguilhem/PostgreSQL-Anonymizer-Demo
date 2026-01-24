#!/bin/bash

# Script to export sponsor logos from PostgreSQL BYTEA column to JPG files
# Usage: ./3-export_logos.sh [--user postgres_user] [--host host] [--port port] [--db database]

# Default values
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="postgres"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --user|-u)
      DB_USER="$2"
      shift 2
      ;;
    --host|-h)
      DB_HOST="$2"
      shift 2
      ;;
    --port|-p)
      DB_PORT="$2"
      shift 2
      ;;
    --db|-d)
      DB_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--user postgres_user] [--host host] [--port port] [--db database]"
      exit 1
      ;;
  esac
done

echo "Exporting sponsor logos..."
echo "Database: $DB_HOST:$DB_PORT/$DB_NAME"
echo "User: $DB_USER"

# Get sponsor list with id and name (top 5 sorted by id)
QUERY="SELECT id, name FROM sponsor WHERE id <= 5 ORDER BY id;"

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -A -F'|' -c "$QUERY" | while IFS='|' read -r id name; do
  # Trim whitespace
  id=$(echo "$id" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  name=$(echo "$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  
  # Skip empty lines
  [[ -z "$id" ]] && continue
  
  # Create filenames
  hex_file="${name// /_}_${id}.hex"
  jpg_file="${name// /_}_${id}.jpg"
  
  echo "Exporting: $jpg_file (sponsor ID: $id)"
  
  # Export hexadecimal data to temporary hex file using \copy
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "\copy (SELECT encode(logo, 'hex') FROM sponsor WHERE id = $id) TO '$hex_file'"
  
  if [ $? -eq 0 ]; then
    # Convert hex file to binary JPG file
    while read -N2 code; do printf "\\x$code"; done < "$hex_file" > "$jpg_file"
    
    if [ $? -eq 0 ]; then
      echo "  ✓ Saved to: $jpg_file"
      # Clean up hex file
      rm -f "$hex_file"
    else
      echo "  ✗ Error converting hex to JPG: $jpg_file"
    fi
  else
    echo "  ✗ Error exporting hex data for sponsor ID: $id"
  fi
done

echo "Export complete!"
