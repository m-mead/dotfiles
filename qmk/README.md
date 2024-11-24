# qmk

This is a utility repo for building QMK firmware inside Docker.
It is only intended to work with my keyboards.

## Usage

First, checkout the [qmk_firmware](https://github.com/qmk/qmk_firmware) submodule.
> The location of the checkout can be changed by updating `docker-compose.yml` or specifying a `QMK_DIR` environment variable.

```shell
git clone git@github.com:m-mead/qmk_firmware.git ~/src/qmk_firmware
```

## Building keyboard firmware

Run `make` to build and run the container.

```shell
make
```

The firmware will be placed in `./bin`.

## Changing the keyboard

The keyboard and keymap are specified in `docker-compose.yml` and can be modified.

```yml
    environment:
      - KEYBOARD="lily58"
      - KEYMAP="default"
      - CONVERT_TO="promicro_rp2040"
```
