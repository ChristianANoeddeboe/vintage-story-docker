FROM ubuntu:22.04

WORKDIR /var/vintagestory

COPY start.sh start.sh
COPY backup.sh backup.sh

RUN apt update && apt upgrade -y

RUN apt install -y screen wget curl cron

RUN apt install -y dotnet-sdk-7.0

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
RUN wget https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${VERSION}.tar.gz

# Extract the game server to the server directory
RUN tar -xzf vs_server_linux-x64_${VERSION}.tar.gz -C server

# Remove the archive for space
RUN rm vs_server_linux-x64_${VERSION}.tar.gz

# Change directory to the server directory
WORKDIR /var/vintagestory/server

# Make the server executable
RUN chmod +x server.sh

# Make the backup script executable
RUN chmod +x /var/vintagestory/backup.sh

# Create vintagestory user
RUN useradd vintagestory

# Change the username to root
# RUN sed -i "s/username='vintagestory'/username=root/g" server.sh
# Also change the VSPATH='/home/vintagestory/server' to /var/vintagestory/server
RUN sed -i "s/VSPATH='\/home\/vintagestory\/server'/VSPATH='\/var\/vintagestory\/server'/g" server.sh
# Lastly, change DATAPATH='var/vintagestory/data' to /var/vintagestory/data
RUN sed -i "s/DATAPATH='var\/vintagestory\/data'/DATAPATH='\/var\/vintagestory\/data'/g" server.sh

# Add a cron job to run the backup command daily at 01:00
RUN echo "0 1 * * * /var/vintagestory/backup.sh" >> /etc/crontab

# Run the cron daemon in the foreground
CMD ["cron", "-f"]
