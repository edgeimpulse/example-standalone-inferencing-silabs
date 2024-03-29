FROM ubuntu:20.04

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

# APT packages
RUN apt update && apt install -y wget unzip python3 python3-pip git-lfs software-properties-common
RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add -
RUN add-apt-repository 'deb https://apt.corretto.aws stable main'
RUN apt update
RUN apt install -y java-17-amazon-corretto-jdk

# Install git LFS to get a full Gecko SDK
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt install -y git-lfs

# GCC ARM
RUN cd / && \
    wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2019q4/RC2.1/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 -q && \
    tar xjf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 && \
    echo "PATH=$PATH:/gcc-arm-none-eabi-9-2019-q4-major/bin" >> ~/.bashrc

# Gecko SDK
WORKDIR /
RUN GECKO_COMMIT=db4e90767174d467158d4c5249ba5be6ab9d9e83 && \
    git clone https://github.com/edgeimpulse/gecko_sdk && \
    cd gecko_sdk && \
    git checkout ${GECKO_COMMIT}

# SLC-CLI tool
WORKDIR /
RUN wget https://cdn.edgeimpulse.com/build-system/slc_cli_linux.zip -q && \
    unzip -q slc_cli_linux.zip && \
    cd slc_cli && \
    pip3 install --user -r requirements.txt && \
    chmod +x slc

ENV PATH="/slc_cli:${PATH}"

WORKDIR /app

RUN slc configuration --sdk /gecko_sdk/ && \
    slc signature trust --sdk /gecko_sdk/ && \
    slc configuration --gcc-toolchain /gcc-arm-none-eabi-9-2019-q4-major
