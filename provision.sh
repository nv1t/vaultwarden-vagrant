set -eux

apt-get -y update 
apt-get -y upgrade

# Generating Directories
mkdir -p /opt/vaultwarden/
ln -s /vagrant/data /opt/vaultwarden/ || echo 'File exists'

# Install Dependencies for building vaultwarden from source
apt-get -y install cargo 
apt-get -y install git nano curl wget htop pkg-config openssl libssl3 libssl-dev 
apt-get -y install build-essential 

git clone https://github.com/dani-garcia/vaultwarden.git /root/vaultwarden
cd /root/vaultwarden
cargo build --release --features sqlite
cp /root/vaultwarden/target/release/vaultwarden /opt/vaultwarden/
rm -r /root/vaultwarden

# Download the Bitwarden Web interface as binary release
cd /opt/vaultwarden/
curl -L --output bw_web.tar.gz https://github.com/dani-garcia/bw_web_builds/releases/download/v2023.2.0/bw_web_v2023.2.0.tar.gz
tar -xf bw_web.tar.gz
rm bw_web.tar.gz

# Generating the Vaultwarden Service
cat <<EOT > /etc/systemd/system/vaultwarden.service
[Unit]
Description=Vaultwarden
After=caddy.service

[Service]
Type=simple
Restart=always
# Isolate vaultwarden from the rest of the system
PrivateTmp=true
PrivateDevices=true
ProtectHome=true
ProtectSystem=strict
EnvironmentFile=/etc/vaultwarden.env
WorkingDirectory=/opt/vaultwarden
ReadWriteDirectories=/opt/vaultwarden
ExecStart=/opt/vaultwarden/vaultwarden

[Install]
WantedBy=local.target
EOT

cat <<EOT > /etc/vaultwarden.env
ADMIN_TOKEN=''
EOT

# Installing and configuring caddy
apt-get -y install debian-keyring debian-archive-keyring apt-transport-https 
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list

apt-get -y update 
apt-get -y install caddy

cat <<EOT > /etc/caddy/Caddyfile
:8080 {
    reverse_proxy :8000
}
EOT

# Enabling and starting both
systemctl enable --now caddy
systemctl enable --now vaultwarden

systemctl restart caddy
systemctl restart vaultwarden
