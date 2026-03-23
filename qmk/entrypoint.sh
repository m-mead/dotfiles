#!/usr/bin/env bash

if [[ -z "${KEYBOARD}" || -z "${KEYMAP}" || -z "${CONVERT_TO}" ]]; then
    echo -e "usage: entrypoint.sh"
    echo -e "the following must be set in the environment:"
    echo -e "	KEYBOARD  (current: ${KEYBOARD})"
    echo -e "	KEYMAP    (current: ${KEYMAP})"
    echo -e "   CONVET_TO (current: ${CONVERT_TO})"
    exit 1
fi

echo "building qmk firmware for keyboard configuration ${KEYBOARD}:${KEYMAP} (convert to: ${CONVERT_TO})"

qmk setup
qmk compile -kb ${KEYBOARD} -km ${KEYMAP} --clean -e CONVERT_TO=${CONVERT_TO}

cp ${KEYBOARD}*.hex /qmk_bin > /dev/null 2>&1
cp ${KEYBOARD}*.uf2 /qmk_bin > /dev/null 2>&1

echo "firmware files: $(ls /qmk_bin)"
