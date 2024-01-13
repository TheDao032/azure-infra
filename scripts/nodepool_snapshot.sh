CLUSTER=""
RESOURCE_GROUP=""
NODEPOOL=""

NODEPOOL_ID=$(az aks nodepool show --name ${NODEPOOL} --cluster-name ${CLUSTER} --resource-group ${RESOURCE_GROUP} --query id -o tsv)
CURRENT_DATE=$(date +%s)
SNAPSHOT="${NODEPOOL}-${CURRENT_DATE}-snapshot"

az aks nodepool snapshot create --name ${SNAPSHOT} --resource-group ${RESOURCE_GROUP} --nodepool-id ${NODEPOOL_ID} --location southeastasia
az aks nodepool snapshot show --name ${SNAPSHOT} --resource-group ${RESOURCE_GROUP} --query id -o tsv