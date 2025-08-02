apt update
apt -y --no-install-recommends install curl libgdiplus lib32gcc-s1 ca-certificates netcat-openbsd

cd /tmp
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

mkdir -p /mnt/server/steam
tar -xzvf steamcmd.tar.gz -C /mnt/server/steam
cd /mnt/server/steam

chown -R root:root /mnt

export HOME=/mnt/server
./steamcmd.sh +@sSteamCmdForcePlatformBitness 64 +login anonymous +force_install_dir /mnt/server +app_update 1110390 +quit

mkdir -p /mnt/server/Servers/unturned/Server
touch /mnt/server/Servers/unturned/Server/Commands.dat

find_available_port() {
    local start_port=27000
    local end_port=27300
    local port=$start_port
    
    while [ $port -le $end_port ]; do
        if ! ss -tuln | grep -q ":$port "; then
            echo $port
            return 0
        fi
        port=$((port + 1))
    done
    
    echo $start_port
}


SECOND_PORT=$(find_available_port)
echo "Allocated port -> $SECOND_PORT"
echo $SECOND_PORT > /mnt/server/allocated_port.txt