FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install desktop & VNC
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tightvncserver \
    wget curl git \
    dbus-x11

# Buat user
RUN useradd -m user
WORKDIR /home/user
USER user

# Set password VNC
RUN mkdir -p ~/.vnc
RUN echo "123456" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Startup script
RUN echo '#!/bin/bash\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > ~/.vnc/xstartup

RUN chmod +x ~/.vnc/xstartup

# Expose port
EXPOSE 5901

CMD ["vncserver", ":1", "-geometry", "1280x720", "-depth", "24"]
