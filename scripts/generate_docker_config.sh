#!/bin/bash

# Path to your service account key
SERVICE_ACCOUNT_KEY_PATH="$1"

# Ensure the service account key path is provided
if [[ -z "$SERVICE_ACCOUNT_KEY_PATH" ]]; then
    echo "Please provide the service account key path."
    exit 1
fi

# Use Python to replace the placeholder with actual JSON content
python3 -c "
import json

# Load the template file
with open('./crds/Secrets/.dockerconfigjson.template', 'r') as f:
    template = f.read()

# Load the service account key and convert it to a compact JSON string
with open('$SERVICE_ACCOUNT_KEY_PATH', 'r') as f:
    service_account_content = json.dumps(json.load(f))

# Replace the placeholder and write the result
with open('.dockerconfigjson', 'w') as f:
    f.write(template.replace('\"[YOUR-SERVICE-ACCOUNT-KEY]\"', service_account_content))
"

echo ".dockerconfigjson has been generated!"
