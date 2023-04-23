# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04

# Install spotify
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libpangoxft-1.0-0 libpangox-1.0-0 xauth libasound2 xvfb net-tools curl python gnupg gnupg2 gnupg1 
RUN DEBIAN_FRONTEND=noninteractive curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | apt-key add - 
RUN DEBIAN_FRONTEND=noninteractive echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install spotify-client && apt-get clean
RUN DEBIAN_FRONTEND=noninteractive apt install linux-image-generic -y
RUN DEBIAN_FRONTEND=noninteractive touch /root/.asoundrc
RUN DEBIAN_FRONTEND=noninteractive touch /etc/asound.conf
RUN DEBIAN_FRONTEND=noninteractive echo 'pcm.!default = null;' >> /root/.asoundrc
RUN DEBIAN_FRONTEND=noninteractive echo 'pcm.!default = null;' >> /etc/asound.conf
RUN DEBIAN_FRONTEND=noninteractive apt install pulseaudio alsa-utils -y
RUN DEBIAN_FRONTEND=noninteractive echo 'snd_aloop' >> /etc/modules
RUN DEBIAN_FRONTEND=noninteractive touch /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo '[Unit]' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo 'Description=PulseAudio system server' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo '# DO NOT ADD ConditionUser=!root' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo '' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo '[Service]' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo 'Type=notify' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo 'ExecStart=pulseaudio --daemonize=no --system --realtime --log-target=journal' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo 'Restart=on-failure' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo '' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo '[Install]' >> /etc/systemd/system/pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo 'WantedBy=multi-user.target' >> /etc/systemd/system/pulseaudio.service
#RUN DEBIAN_FRONTEND=noninteractive systemctl --system enable --now pulseaudio.service
RUN DEBIAN_FRONTEND=noninteractive echo 'default-server = /var/run/pulse/native' >> /etc/pulse/client.conf
RUN DEBIAN_FRONTEND=noninteractive echo 'autospawn = no' >> /etc/pulse/client.conf
RUN DEBIAN_FRONTEND=noninteractive usermod -aG pulse-access root
RUN apt-get install -y wget
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Spotify_logo_without_text.svg/768px-Spotify_logo_without_text.svg.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Copy the start script.
COPY startapp.sh /startapp.sh

# FileBrowser port
EXPOSE 8080

# Add files.
COPY rootfs/ /

# Set the name of the application.
ENV APP_NAME="Spotify"
