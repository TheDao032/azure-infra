#!/bin/bash
set -e

# Variables
VM_USER=$1
ARM_CLIENT_ID=$2
ARM_CLIENT_SECRET=$3
ARM_TENANT_ID=$4
AZP_URL=$5
AZP_TOKEN=$6
AZP_POOL=$7
AZP_AGENT_NAME=$8
TARGETARCH=$9
CR_PASSWORD=${10}
CR_NAME=${11}

if [ -z "$VM_USER" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
else
  echo "Virtual Machine Admin User: $VM_USER" | tee /dev/stderr 
fi
 
if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
else
  echo "Azure DevOps URL: $AZP_URL" | tee /dev/stderr 
fi

if [ -z "$AZP_TOKEN" ]; then
  echo 1>&2 "error: missing AZP_TOKEN environment variable"
  exit 1
fi

if [ -z "$AZP_POOL" ]; then
  echo "Azure DevOps PAT: Default"
else
  echo "Azure DevOps PAT: $AZP_POOL" | tee /dev/stderr 
fi

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

export AGENT_ALLOW_RUNASROOT="1"

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
export DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" | tee /etc/apt/apt.conf.d/90assumeyes

# Update the system
sudo apt-get update

# Upgrade packages
# apt-get upgrade -y

# Install software
sudo apt-get install -y -qq \
  lsb-release \
  git \
  ca-certificates \
  curl \
  netcat \
  zip \
  wget \
  apt-transport-https \
  apt-utils \
  software-properties-common \
  postgresql

# Setup docker. For more information, see https://docs.docker.com/engine/install/linux-postinstall/
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker $VM_USER
printf "{\"data-root\": \"/datadrive/docker\"}" | tee -a /etc/docker/daemon.json

wget https://github.com/aquasecurity/trivy/releases/download/v0.19.2/trivy_0.19.2_Linux-64bit.deb
dpkg -i trivy_0.19.2_Linux-64bit.deb

# Install kubectl (latest)
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&
  chmod +x ./kubectl &&
  mv ./kubectl /usr/local/bin/kubectl

# Install helm v3 (latest)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &&
  chmod 700 get_helm.sh &&
  ./get_helm.sh

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

az login --service-principal --username ${ARM_CLIENT_ID} --password ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}
az feature register --name WindowsPreview --namespace Microsoft.ContainerService
az acr login --name ${CR_NAME} --username ${CR_NAME} --password ${CR_PASSWORD}

docker login ${CR_NAME}.azurecr.io -u ${CR_NAME} -p ${CR_PASSWORD}
docker pull ${CR_NAME}.azurecr.io/infra:latest

docker run -d -e AZP_URL=${AZP_URL} -e AZP_TOKEN=${AZP_TOKEN} -e AZP_POOL=${AZP_POOL} -e AZP_AGENT_NAME=${AZP_AGENT_NAME} -e ARM_CLIENT_ID=${ARM_CLIENT_ID} -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} -e ARM_TENANT_ID=${ARM_TENANT_ID} -e TARGETARCH=${TARGETARCH} --restart=always --name "terraform-agent" ${CR_NAME}.azurecr.io/infra:latest

exit 0
