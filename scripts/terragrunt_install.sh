# ---------------------------------------------------------------------------------------------------------------------
# THIS SCRIPT DOWNLOADS AND INSTALLS TERRAGRUNT
#
# Required envirnoment variable:
# TERRAGRUNT_VERSION      - The version of terragrunt
# TERRAGRUNT_DOWNLOAD_SHA - The sha256sum of the downloaded file
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail

TERRAGRUNT_VERSION=0.53.4

# Download the binary file and save it as 'terragrunt'
mkdir terragrunt
cd terragrunt
curl -SL "https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_amd64" --output terragrunt

# Verify the sha256sum of the downloaded file
# echo "${TERRAGRUNT_DOWNLOAD_SHA} terragrunt" | sha256sum -c -

# Copy the file to /usr/local/bin so we don't have to specify the full path
sudo cp -a terragrunt /usr/local/bin

# Make the file executable
chmod +x /usr/local/bin/terragrunt

# Test if it works, by printing out the version of terragrunt
terragrunt --version
