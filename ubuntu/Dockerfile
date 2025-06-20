FROM ubuntu:jammy

COPY bashrc /root/.bashrc

WORKDIR /mssql

RUN apt-get update && apt-get install curl -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update
