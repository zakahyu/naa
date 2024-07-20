# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Prevent interactive dialogue during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    && add-apt-repository ppa:qbittorrent-team/qbittorrent-stable \
    && apt-get update && apt-get install -y \
    qbittorrent-nox \
    rclone \
    && apt-get clean

# Create a new user with a home directory
RUN useradd -m -s /bin/bash qbittorrent

# Create necessary directories with appropriate permissions
RUN mkdir -p /home/qbittorrent/.config/qBittorrent && \
    chown -R qbittorrent:qbittorrent /home/qbittorrent/.config

# Switch to the new user
USER qbittorrent

# Set password for qbittorrent-nox
RUN qbittorrent-nox --daemon --webui-port=8080 && sleep 5 && pkill qbittorrent-nox
RUN echo "123456" | qbittorrent-nox --webui-port=8080 --daemon && sleep 5 && pkill qbittorrent-nox

# Expose the qBittorrent Web UI port
EXPOSE 8080

# Command to run qbittorrent-nox
CMD ["qbittorrent-nox", "--webui-port=8080"]
