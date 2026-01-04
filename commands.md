```
1. Repo Link: https://github.com/atulkamble/azure-keyvault-github-token-pipeline#

2. maintain azure-pipelines.yml

3. create project - import git repo 

4. run pipeline

5. Github Connections - add Github Account 

6. Select Project Repo - azure-keyvault-github-token-pipeline from Github 

7. Create Github Token - azure-pipeline-token - copy token - 

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

8. 

az login

az group create \
  --name rg-kv-demo \
  --location eastus

az keyvault create \
  --name kv-github-demo \
  --resource-group rg-kv-demo \
  --location eastus

az role assignment create \
  --assignee 569e301d-629a-4d19-a477-a250605ef6ba \
  --role "Key Vault Secrets Officer" \
  --scope /subscriptions/50818730-e898-4bc4-bc35-d998af53d719/resourceGroups/rg-kv-demo/providers/Microsoft.KeyVault/vaults/kv-github-demo


az keyvault secret set \
  --vault-name kv-github-demo \
  --name github-token \
  --value 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

9. Project Setting >> Service Connection >> New service connection >> Azure Resource Manager >> Set Popup 

>> select Resource Group (rg-kv-demo) >> Connection name: azure-kv-connection >> Not Down Service Principal ID (bff365bd-658f-43e6-bfb1-e6a784739ac2)

10. 

az ad sp list 

az ad signed-in-user show \
  --query "{user:userPrincipalName, objectId:id}" \
  --output table


az keyvault set-policy \
  --name kv-github-demo \
  --spn bff365bd-658f-43e6-bfb1-e6a784739ac2 \
  --secret-permissions get list

az role assignment create \
  --assignee 569e301d-629a-4d19-a477-a250605ef6ba \
  --role "Key Vault Secrets Officer" \
  --scope /subscriptions/50818730-e898-4bc4-bc35-d998af53d719/resourceGroups/rg-kv-demo/providers/Microsoft.KeyVault/vaults/kv-github-demo

az keyvault secret show \
  --vault-name kv-github-demo \
  --name github-token \
  --query "id"

11. 

Pipelines >> Library >> kv-secrets >> Link secrets from Azure Key Vault Variables 

Select >> azure-kv-connection
Select >> kv-github-demo

(Autorise PopUp)

12.

chmod +x ./assign-keyvault-permissions.sh
./assign-keyvault-permissions.sh





```
