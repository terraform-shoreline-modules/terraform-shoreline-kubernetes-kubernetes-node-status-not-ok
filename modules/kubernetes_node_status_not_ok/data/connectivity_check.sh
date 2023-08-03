
#!/bin/bash

# Get the list of nodes in the Kubernetes cluster
NODES=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')

# Loop over each node and check the connectivity to the control plane
for NODE in $NODES; do
  echo "Checking connectivity to control plane from node $NODE..."
  kubectl exec -it ${POD_NAME} -n ${POD_NAMESPACE} -- ping -c 3 ${CONTROL_PLANE_IP}
done