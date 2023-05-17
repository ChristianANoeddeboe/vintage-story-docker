FROM ubuntu:20.04

WORKDIR /var/vintagestory

COPY start.sh start.sh

RUN apt update && apt upgrade -y

RUN apt install -y screen wget curl

RUN apt install -y gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y mono-complete

# Get version from compose env variable
ARG VERSION

# Create the server directory
RUN mkdir server

# Download the game server
RUN wget https://cdn.vintagestory.at/gamefiles/stable/vs_server_${VERSION}.tar.gz

# Extract the game server to the server directory
RUN tar -xzf vs_server_${VERSION}.tar.gz -C server

# Remove the archive
RUN rm vs_server_${VERSION}.tar.gz

# Change directory to the server directory
WORKDIR /var/vintagestory/server

# Make the server executable
RUN chmod +x server.sh

# Create vintagestory user
RUN useradd vintagestory

# # Now open the server.sh file and change the username to root
# RUN sed -i "s/username='vintagestory'/username=root/g" server.sh
# Also change the VSPATH='/home/vintagestory/server' to /var/vintagestory/server
RUN sed -i "s/VSPATH='\/home\/vintagestory\/server'/VSPATH='\/var\/vintagestory\/server'/g" server.sh
# Lastly, change DATAPATH='var/vintagestory/data' to /var/vintagestory/data
RUN sed -i "s/DATAPATH='var\/vintagestory\/data'/DATAPATH='\/var\/vintagestory\/data'/g" server.sh

