#!/bin/bash

LOCATION=$1
RESOURCE_GROUP=$2
STORAGE_ACCOUNT_NAME=$3
CONTAINER=$4
ARM_CLIENT_ID=$5
ARM_CLIENT_SECRET=$6
ARM_TENANT_ID=$7
VELERO_CONTAINER=$8

# ARM_CLIENT_ID=${9}
# ARM_CLIENT_SECRET=${10}
# ARM_TENANT_ID=${11}
AZP_URL=${9}
AZP_TOKEN=${10}
AZP_POOL=${11}
AZP_AGENT_NAME=${12}
TARGETARCH=${13}
CR_PASSWORD=${14}
CR_NAME=${15}

VM_NAME=${16:-self-agent-host}
VM_USER=${17:-admin}
# CONTAINER_REGISTRY_NAME=$9

az login --service-principal --username ${ARM_CLIENT_ID} --password ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

az group create --location ${LOCATION} --name ${RESOURCE_GROUP}

az storage account create --name ${STORAGE_ACCOUNT_NAME} --resource-group ${RESOURCE_GROUP} --location ${LOCATION} --sku Standard_LRS
az storage container create --name ${CONTAINER} --account-name ${STORAGE_ACCOUNT_NAME}
az storage container create --name ${VELERO_CONTAINER} --account-name ${STORAGE_ACCOUNT_NAME}

# az vm create -n ${VM_NAME} -g ${RESOURCE_GROUP} --image Ubuntu2204 --size Standard_B2s --security-type Standard --generate-ssh-keys --admin-username ${VM_USER}
#
# az vm run-command -g ${RESOURCE_GROUP} -n ${VM_NAME} --command-id RunShellScript --script-file configure_self_host_agent.sh --parameters ${VM_USER} ${ARM_CLIENT_ID} ${ARM_CLIENT_SECRET} ${ARM_TENANT_ID} ${AZP_URL} ${AZP_TOKEN} ${AZP_POOL} ${AZP_AGENT_NAME} ${TARGETARCH} ${CR_PASSWORD} ${CR_NAME}

# az acr create -n ${CONTAINER_REGISTRY_NAME} -g ${RESOURCE_GROUP} --sku Premium --admin-enabled true --allow-exports true --allow-trusted-services true --default-action Allow
