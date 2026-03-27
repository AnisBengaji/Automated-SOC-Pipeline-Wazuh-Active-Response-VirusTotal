#!/bin/bash

LOCAL=`dirname $0`
cd $LOCAL
cd ../

PWD=`pwd`
LOG_FILE="${PWD}/logs/active-responses.log"
TIMESTAMP=`date "+%Y/%m/%d %H:%M:%S"`

read INPUT_JSON


echo "${TIMESTAMP} remove-threat: Raw input: ${INPUT_JSON}" >> ${LOG_FILE}


FILENAME=$(echo $INPUT_JSON | grep -o '"syscheck\.path":"[^"]*"' | head -1 | cut -d'"' -f4)


if [ -z "$FILENAME" ]; then
    FILENAME=$(echo $INPUT_JSON | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    path = data.get('parameters', {}).get('alert', {}).get('syscheck', {}).get('path', '')
    print(path)
except:
    print('')
" 2>/dev/null)
fi

echo "${TIMESTAMP} remove-threat: Extracted path: ${FILENAME}" >> ${LOG_FILE}

if [ -z "$FILENAME" ]; then
    echo "${TIMESTAMP} remove-threat: ERROR - Could not extract filename" >> ${LOG_FILE}
    exit 1
fi

if [ -f "$FILENAME" ]; then
    rm -f "$FILENAME"
    if [ $? -eq 0 ]; then
        echo "${TIMESTAMP} remove-threat: SUCCESS - Removed: ${FILENAME}" >> ${LOG_FILE}
    else
        echo "${TIMESTAMP} remove-threat: ERROR - Failed to remove: ${FILENAME}" >> ${LOG_FILE}
    fi
else
    echo "${TIMESTAMP} remove-threat: WARNING - File not found: ${FILENAME}" >> ${LOG_FILE}
fi

exit 0
