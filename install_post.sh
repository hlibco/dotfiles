# ==============================================================================
# SSH KEYS
# ==============================================================================
echo "Creating SSH Keys:"

# Create destination folder and file
sudo mkdir /etc/ssl && mkdir /etc/ssl/certs
sudo touch /etc/ssl/certs/ca-certificates.crt

# Create certificate file to use on Gitlab-ci runner
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:4096 -keyout gitlab.key -out /etc/ssl/certs/gitlab.pem

# Copy the key to the right location
sudo tee -a /etc/ssl/certs/ca-certificates.crt < /etc/ssl/certs/gitlab.pem

# Create certificate file to use on Terraform AWS
sudo openssl genrsa -des3 -passout pass:x -out /etc/ssl/certs/server.pass.key 2048
sudo openssl rsa -passin pass:x -in /etc/ssl/certs/server.pass.key -out /etc/ssl/certs/server.key
sudo rm -f /etc/ssl/certs/server.pass.key
sudo openssl req -new -key /etc/ssl/certs/server.key -out /etc/ssl/certs/server.csr
sudo openssl x509 -req -sha256 -days 365 -in /etc/ssl/certs/server.csr -signkey /etc/ssl/certs/server.key -out /etc/ssl/certs/server.crt

# Databases
# ==============================================================================
echo "Installing Mongodb"
brew install mongodb --with-openssl
mkdir -p /data/db && chmod 777 /data/db

# Node
# ==============================================================================
echo "Installing nvm (https://github.com/creationix/nvm)"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

echo "Installing Node"
nvm install node

echo "Node info"
npm which
npm -v
