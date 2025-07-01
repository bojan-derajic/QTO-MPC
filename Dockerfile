FROM python:3.11-slim

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    xauth \
    libblas-dev \
    liblapack-dev \
    libmetis-dev \
    pkg-config \
    gfortran \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /casadi_ws
WORKDIR /casadi_ws

COPY ./requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG sudo $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD ["/bin/bash"]