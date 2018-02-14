# SCRIPT for the 
# REQUIRES: root privileges
# USING FILES: docker-compose.yml
#
echo "================================"
echo "Welcome to the deployment script"
echo "================================"
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# TODO: install git and docker engine
echo "Installing git"
echo "================================"
apt-get update
apt-get -y install git

echo "============================="
echo "installing docker"
echo "============================="
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh && rm get-docker.sh

# change to root
echo "============================="
echo "downloading docker-compose..."
echo "============================="
curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# option for speeding up the docker
echo "================================"
echo "adding overlay as kernel module"
echo "================================"
modprobe overlay
echo """
{
  \"storage-driver\": \"overlay2\"
}
""" >> /etc/docker/daemon.sh

# apply changes
echo "================="
echo "restarting docker"
echo "================="
systemctl restart docker

# run sonarqube, postgresql, gitlab-ci
echo "============================================"
echo "docker-compose up for Gitlab-CI + SonarQube"
echo "============================================"
docker-compose up -d 

# create docker network for the gitlab-runner
echo "================================"
echo "setup configuration for the Runner"
echo "================================"
# create folder for the configuration
mkdir -p /srv/gitlab-runner

# create config file for the runner
touch /srv/gitlab-runner/config.toml

echo "================================"
echo "Run the Runner"
echo "================================"
# run gitlab runner and register it
docker run -it --rm \
  -v /srv/gitlab-runner/config.toml:/etc/gitlab-runner/config.toml \
  gitlab/gitlab-runner:alpine \
    register \
    --executor docker \
    --docker-image tyvision/lia-workshop-ci:clang \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock