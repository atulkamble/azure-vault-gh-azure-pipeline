#!/bin/bash
set -e

# Service Principal Object ID from the pipeline error
ASSIGNEE="45ec9bd4-7276-46bf-93b0-1cd04ac02144"

# Key Vault details
SUBSCRIPTION="08b7b8d4-af42-4972-9517-11ea256ea068"
RESOURCE_GROUP="rg-kv-demo"
KEY_VAULT_NAME="kv-github-demo"

SCOPE="/subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$KEY_VAULT_NAME"

echo "Setting subscription context..."
az account set --subscription "$SUBSCRIPTION"

# Detect the vault's permission model
echo "Detecting Key Vault permission model..."
RBAC_ENABLED=$(az keyvault show \
  --name "$KEY_VAULT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "properties.enableRbacAuthorization" \
  --output tsv)

if [ "$RBAC_ENABLED" = "true" ]; then
  echo "Vault uses Azure RBAC — assigning 'Key Vault Secrets User' role..."
  az role assignment create \
    --assignee "$ASSIGNEE" \
    --role "Key Vault Secrets User" \
    --scope "$SCOPE"
  echo "✓ RBAC role assignment completed!"
else
  echo "Vault uses Access Policies — setting Get and List secret permissions..."
  az keyvault set-policy \
    --name "$KEY_VAULT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --subscription "$SUBSCRIPTION" \
    --object-id "$ASSIGNEE" \
    --secret-permissions get list
  echo "✓ Access policy set successfully!"
fi

echo ""
echo "Note: Permission propagation may take 1-2 minutes. Then re-run the pipeline."
