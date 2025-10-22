Param(
  [Parameter(Mandatory=$true)][string]$SubscriptionId,
  [Parameter(Mandatory=$true)][string]$Location,
  [Parameter(Mandatory=$true)][string]$ResourceGroup,
  [Parameter(Mandatory=$true)][string]$AcrName,
  [Parameter(Mandatory=$true)][string]$AksName
)

az account set --subscription $SubscriptionId

Write-Host "[i] Creating RG $ResourceGroup in $Location"
az group create -n $ResourceGroup -l $Location | Out-Null

Write-Host "[i] Creating ACR $AcrName"
az acr create -g $ResourceGroup -n $AcrName --sku Standard | Out-Null

Write-Host "[i] Creating AKS $AksName"
az aks create -g $ResourceGroup -n $AksName --node-count 1 --generate-ssh-keys | Out-Null

Write-Host "[i] Attaching ACR to AKS"
az aks update -g $ResourceGroup -n $AksName --attach-acr $AcrName | Out-Null

Write-Host "[✔] Done."
