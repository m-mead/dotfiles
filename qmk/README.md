# qmk

This is a utility repo for building QMK firmware inside Docker.
It is only intended to work with my keyboards.

## Usage

Install the dependencies

```shell
make dep
```

Run `make build-{keyboard}` to build the firmware.
This step will use `docker-compose` to build the Docker image, mount the `qmk_firmware` repo, and compile the firmware.

```shell
make build-corne
make build-lily58
```

The firmware will be placed in `./bin`.

```shell
ls -lah bin/
```
