FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV CYCLONEDDS_HOME="/root/cyclonedds/install"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    sudo \
    vim \
    python3 \
    python3-pip \
    python3-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa \
    libglfw3-dev \
    libglew-dev \
    libgl1-mesa-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libxmu-dev \
    libxrender1 \
    libxext6 \
    libx11-6 \
    libglib2.0-0 \
    libeigen3-dev \
    libyaml-cpp-dev \
    libsm6 \
    libxext6 \
    xauth \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./external/unitree_sdk2 /root/unitree_sdk2
WORKDIR /root/unitree_sdk2
RUN mkdir -p build && \
    cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/unitree_robotics && \
    make -j$(nproc) install

COPY ./external/cyclonedds /root/cyclonedds
WORKDIR /root/cyclonedds
RUN mkdir /root/cyclonedds/build && mkdir /root/cyclonedds/install \
    && cd /root/cyclonedds/build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/root/cyclonedds/install \
    && cmake --build . --target install

COPY ./external/mujoco /root/mujoco
WORKDIR /root/mujoco
RUN mkdir -p build && \
    cd build && cmake .. && make -j$(nproc) && make install

COPY ./external/unitree_mujoco /root/unitree_mujoco
WORKDIR /root/unitree_mujoco/simulate
RUN mkdir -p build && cd build && cmake .. && make -j$(nproc)

COPY ./external/unitree_sdk2_python /root/unitree_sdk2_python
WORKDIR /root/unitree_sdk2_python
# RUN pip3 install -e /root/unitree_sdk2_python
RUN python3 -m pip install .
RUN pip3 install mujoco pygame

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /root/unitree_mujoco
ENTRYPOINT ["/entrypoint.sh"]


