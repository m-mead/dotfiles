SHELL := /bin/bash

build-corne:
	KEYBOARD="crkbd/rev1" KEYMAP="default" CONVERT_TO="elite_pi" docker-compose up --build

build-lily58:
	KEYBOARD="lily58" KEYMAP="default" CONVERT_TO="elite_pi" docker-compose up --build

dep:
	./util/download_dep.sh

clean:
	rm -rf bin
