FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
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