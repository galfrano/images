FROM debian:bookworm

COPY bashrc /root/.bashrc

WORKDIR /angular/homes-app
RUN apt-get update && apt-get upgrade -y && apt-get install npm -y && npm install -g @angular/cli
