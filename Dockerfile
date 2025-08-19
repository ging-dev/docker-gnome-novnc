FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
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
    novnc \
    python3-numpy \
    sassc \
    libglib2.0-dev-bin

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

RUN useradd -m -s /bin/bash $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
WORKDIR $HOME

RUN mkdir -p .config/gtk-4.0 && \
    git clone --depth 1 https://github.com/vinceliuice/Mojave-gtk-theme.git && \
    git clone --depth 1 https://github.com/vinceliuice/MacTahoe-icon-theme.git && \
    cd $HOME/Mojave-gtk-theme && ./install.sh -l && \
    cd $HOME/MacTahoe-icon-theme && ./install.sh
RUN rm -rf Mojave-gtk-theme MacTahoe-icon-theme

RUN export $(dbus-launch) && \
    gsettings set org.gnome.desktop.interface gtk-theme Mojave-Light && \
    gsettings set org.gnome.desktop.interface icon-theme MacTahoe-light && \
    gsettings set org.gnome.desktop.wm.preferences button-layout close,minimize,maximize: && \
    gsettings set org.gnome.desktop.screensaver lock-enabled false

RUN mkdir .config/tigervnc && \
    touch .config/tigervnc/passwd && \
    sudo chmod 600 .config/tigervnc/passwd

COPY start.sh start.sh
RUN sudo chmod +x start.sh

CMD [ "/home/vncuser/start.sh" ]
EXPOSE 6080
