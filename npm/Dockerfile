FROM debian:bookworm

COPY bashrc /root/.bashrc

WORKDIR /npm
RUN apt-get update && apt-get upgrade -y && apt-get install npm -y
