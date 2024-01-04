ENV=$1
VELERO_VERSION=1.12.2
export AZURE_RESOURCE_GROUP=$2
export AZURE_SUBSCRIPTION_ID=$3
export AZURE_CLIENT_ID=$4
export AZURE_CLIENT_SECRET=$5
export AZURE_TENANT_ID=$6
export AZURE_CLOUD_NAME="AzureCloud"

AKS_CLUSTER=$7
STORAGE_ACCOUNT_NAME=$8
VELERO_CONTAINER=${9:-velero-backup}
VM_USERNAME=${10:-adminuser}

az aks get-credentials --name ${AKS_CLUSTER} --resource-group ${AZURE_RESOURCE_GROUP} --admin --overwrite-existing

# Install Istio
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
helm upgrade --install istiod istio/istiod -n istio-system --create-namespace

# Install Ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace

# Install Velero
wget https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-amd64.tar.gz
tar -zxvf velero-v${VELERO_VERSION}-linux-amd64.tar.gz

mv velero-v${VELERO_VERSION}-linux-amd64/velero /usr/local/bin/

velero install --provider azure --bucket ${VELERO_CONTAINER} --plugins velero/velero-plugin-for-microsoft-azure:v1.8.0 --backup-location-config resourceGroup=${AZURE_RESOURCE_GROUP},storageAccount=${STORAGE_ACCOUNT_NAME} --no-secret --snapshot-location-config apiTimeout=120
