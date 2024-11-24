#!/usr/bin/env bash

if [[ -z "${KEYBOARD}" || -z "${KEYMAP}" ]]; then
		echo -e "usage: entrypoint.sh"
		echo -e "the following must be set in the environment:"
		echo -e "	KEYBOARD (current: ${KEYBOARD})"	
		echo -e "	KEYMAP (current: ${KEYMAP})"	
		exit 1
fi

echo "building qmk firmware for keyboard configuration ${KEYBOARD}:${KEYMAP}"

qmk setup
qmk compile -kb ${KEYBOARD} -km ${KEYMAP} --clean

cp ${KEYBOARD}*.hex /qmk_bin
cp ${KEYBOARD}*.uf2 /qmk_bin

echo "firmware files: $(ls /qmk_bin)"
