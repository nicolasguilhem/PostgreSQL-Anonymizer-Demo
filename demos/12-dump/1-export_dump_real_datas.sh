#!/bin/bash

DUMP_FILE="dump_$(date +%Y%m%d_%H%M%S).sql"

echo "Exporting database structure and data..."
START_TIME=$(date +%s)

pg_dump \
  --user="postgres" \
  --no-password \
  --verbose \
  postgres > "$DUMP_FILE"



END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "Export completed successfully to $DUMP_FILE"
echo "Duration: ${DURATION}s ($(($DURATION / 60))m $(($DURATION % 60))s)"
