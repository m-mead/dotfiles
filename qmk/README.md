# qmk

This is a utility repo for building QMK firmware inside Docker.
It is only intended to work with my keyboards.

## Usage

Install the dependencies

```shell
make dep
```

Run `make` to build the firmware.
This step will use `docker-compose` to build the Docker image, mount the `qmk_firmware` repo, and compile the firmware.

```shell
make
```

The firmware will be placed in `./bin`.

```shell
ls -lah bin/
```

## Changing the keyboard

The keyboard and keymap are specified in `docker-compose.yml` and can be modified.

```yml
    environment:
      # Required
      - KEYBOARD="lily58"
      - KEYMAP="default"
      # Optional
      - CONVERT_TO="promicro_rp2040"
```
