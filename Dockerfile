FROM debian:jessie

MAINTAINER Suchipi Izumi "me@suchipi.com"

# SteamCMD and deps

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install lib32gcc1 wget
RUN mkdir /steamcmd
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

# Get TF2

RUN mkdir /tf2
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /tf2 +app_update 232250 validate +quit

# Setup Libs for TF2 SRCDS

RUN mkdir -p /root/.steam/sdk32
RUN cp /steamcmd/linux32/steamclient.so /root/.steam/sdk32/steamclient.so
RUN dpkg --add-architecture i386
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install lib32ncurses5 lib32gcc1 libstdc++6 libstdc++6:i386 libcurl4-gnutls-dev:i386 libtcmalloc-minimal4:i386

# Setup Container

ENV G_HOSTNAME="TF2 Server"
ENV SV_PURE="1"
ENV MAXPLAYERS="24"
ENV MAP="koth_nucleus"
ENV PORT="27015"

ADD start-server.sh /start-server.sh
EXPOSE 27015/udp

CMD ["/bin/sh", "/start-server.sh"]
