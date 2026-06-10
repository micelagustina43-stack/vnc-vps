FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update dan install dependencies
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tightvncserver \
    novnc websockify \
    wget curl git \
    dbus-x11 \
    xfonts-base \
    x11-xserver-utils \
    && apt clean

# Buat user baru
RUN useradd -m user
WORKDIR /home/user
USER user

# Setup password VNC
RUN mkdir -p /home/user/.vnc
RUN echo "123456" | vncpasswd -f > /home/user/.vnc/passwd
RUN chmod 600 /home/user/.vnc/passwd

# Setup xstartup
RUN echo '#!/bin/bash\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > /home/user/.vnc/xstartup

RUN chmod +x /home/user/.vnc/xstartup

# Clone noVNC
RUN git clone https://github.com/novnc/noVNC.git /home/user/noVNC
RUN git clone https://github.com/novnc/websockify /home/user/noVNC/utils/websockify

# Expose port web (noVNC)
EXPOSE 8080

# Start VNC server dan noVNC
CMD vncserver :1 -geometry 1280x720 -depth 24 && \
    websockify --web=/home/user/noVNC 8080 localhost:5901
