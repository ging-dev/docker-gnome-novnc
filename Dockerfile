FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    USER=vncuser \
    HOME=/home/vncuser

RUN apt-get update && \
    apt-get install -y \
    git \
    sudo \
    wget \
    dbus-x11 \
    desktop-base \
    gnome-session-flashback \
    nautilus \
    gnome-terminal \
    firefox-esr \
    tigervnc-standalone-server \
    python3-numpy

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

USER $USER
WORKDIR $HOME

RUN git clone --depth 1 https://github.com/novnc/noVNC.git

COPY entrypoint.sh entrypoint.sh
RUN sudo chmod +x entrypoint.sh

ENTRYPOINT [ "/home/vncuser/entrypoint.sh" ]
EXPOSE 6080
