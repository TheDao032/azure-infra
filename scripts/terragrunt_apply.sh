# ---------------------------------------------------------------------------------------------------------------------
# RUN TERRAGRUNT APPLY-ALL, OUTPUT THE APPLY TO THE TERMINAL AND TO A LOG FILE
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail

export ENVIRONMENT=${2}
export RESOURCE_GROUP_NAME=${3}
export STORAGE_ACCOUNT_NAME=${4}
export STORAGE_ACCOUNT_KEY=${5}
export SUBSCRIPTION_ID=${6}
export CONTAINER_NAME=${7}
export LOCATION=${8}

export ARM_CLIENT_ID=${9}
export ARM_CLIENT_SECRET=${10}
export ARM_TENANT_ID=${11}
export ARM_OBJECT_ID=${12}

export JUMPBOX_PASSWD=${13}

export AZP_AGENT_URL=${14}
export AZP_TOKEN=${15}
export AZP_POOL=${16}
export AZP_AGENT_NAME=${17}
export TARGETARCH=${18}
export CR_PASSWORD=${19}
export CR_NAME=${20}

LOG_FILE_NAME=${1:-apply-${ENVIRONMENT}.log}

az login --service-principal --username ${ARM_CLIENT_ID} --password ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

# Run plan all and display output both to terminal and the log file temp.log
cd terraform/environments/subscription-${ENVIRONMENT}/${LOCATION}/${ENVIRONMENT}
terragrunt run-all apply --terragrunt-non-interactive --terragrunt-include-external-dependencies 2>&1 | tee temp.log

sed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" temp.log > ${LOG_FILE_NAME}
