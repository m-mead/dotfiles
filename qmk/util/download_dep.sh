#!/usr/bin/env bash

QMK_HOME=${QMK_HOME:-$HOME/src/qmk_firmware}

if [ -d "${QMK_HOME}" ]; then
        echo "found qmk_firmware checkout: ${QMK_HOME}"
        exit 0
fi

git clone git@github.com:m-mead/qmk_firmware.git ${QMK_HOME}

echo "cloned qmk_firmware to ${QMK_HOME}"
