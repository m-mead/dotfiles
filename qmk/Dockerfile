FROM ubuntu:24.04

RUN DEBIAN_FRONTEND='noninteractive' apt-get update -y && \
    apt install -y \
        avr-libc \
        avrdude \
        binutils-arm-none-eabi \
        binutils-avr \
        binutils-riscv64-unknown-elf \
        build-essential \
        ca-certificates \
        ca-certificates \
        dfu-programmer \
        dfu-util \
        dos2unix \
        gcc \
        gcc-arm-none-eabi \
        gcc-avr \
        gcc-riscv64-unknown-elf \
        git \
        git \
        libfl2 \
        libnewlib-arm-none-eabi \
        picolibc-riscv64-unknown-elf \
        python3 \
        python3-pip \
        python3-pip \
        python3-venv \
        software-properties-common \
        tar \
        tar \
        teensy-loader-cli \
        unzip \
        wget \
        zip

RUN python3 -m venv /opt/qmk-venv
ENV PATH=/opt/qmk-venv/bin:$PATH

RUN python3 -m pip install qmk

COPY --chmod=0755 entrypoint.sh /entrypoint.sh

CMD [ "/entrypoint.sh" ]
