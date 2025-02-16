echo "Microsoft Ready - Setup Labs Script"

# setup variables

uniqueKey=$(date +%s | sha256sum | base64 | head -c 5 ; echo)
rg="ckad-rg-$uniqueKey" 
aksName="ckad-aks-$uniqueKey"
github="https://github.com/liammoat/ckad-workshop.git"

# clear existing

rm -rf ~/ckad

# create resource group

echo "Creating resource group: $rg"
az group create -l westus -n $rg -o table

# deploy aks cluster

echo "Creating AKS cluster: $aksName"
az aks create \
    --resource-group $rg \
    --name $aksName \
    --node-count 2 \
    --generate-ssh-keys \
    -o table

# obtain aks credentials

echo "Obtain AKS cluster credentials: $aksName"
az aks get-credentials --resource-group $rg --name $aksName

# Create namespace Fireworks 
echo "Creating namespace fireworks..."
kubectl create namespace fireworks

echo "Creating namespace demospace..."
kubectl create namespace demospace
kubectl run nginx --image nginx --restart Never --namespace demospace

# clone github repository
echo "Clone GitHub repository: $github"
git clone $github ~/ckad
cd ~/ckad
code .