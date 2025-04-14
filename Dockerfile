FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

CMD ["xeyes"]
