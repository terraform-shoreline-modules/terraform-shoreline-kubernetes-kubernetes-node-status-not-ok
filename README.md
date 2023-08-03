
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes Node Status Not OK
---

This incident type occurs when the Kubernetes node status is not OK. It means that the scheduler cannot place pods on the node due to some underlying issue with the node's health. This incident can impact the availability and performance of the applications running on the Kubernetes cluster. Immediate attention is required to resolve this incident to restore the normal functioning of the Kubernetes cluster.

### Parameters
```shell
# Environment Variables
export NODE_NAME="PLACEHOLDER"
export CONTROL_PLANE_IP="PLACEHOLDER"
export POD_NAMESPACE="PLACEHOLDER"
export POD_NAME="PLACEHOLDER"
export CPU_THRESHOLD="PLACEHOLDER"
export MEMORY_THRESHOLD="PLACEHOLDER"
```

## Debug

### List all nodes in the Kubernetes cluster
```shell
kubectl get nodes
```

### Check the status of a specific node <node-name>
```shell
kubectl describe node ${NODE_NAME}
```

### Check the events associated with a specific node <node-name>
```shell
kubectl get events --field-selector involvedObject.kind=Node,involvedObject.name=${NODE_NAME}
```

### Check the health status of the kubelet service on the node <node-name>
```shell
systemctl status kubelet.service --node ${NODE_NAME}
```

### Check the logs for the kubelet service on the node <node-name>
```shell
journalctl -u kubelet.service --node ${NODE_NAME}
```

### Check the status of the Docker service on the node <node-name>
```shell
systemctl status docker.service --node ${NODE_NAME}
```

### Check the logs for the Docker service on the node <node-name>
```shell
journalctl -u docker.service --node ${NODE_NAME}
```

### Network or connectivity issues between the Kubernetes nodes and the control plane.
```shell

#!/bin/bash

# Get the list of nodes in the Kubernetes cluster
NODES=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')

# Loop over each node and check the connectivity to the control plane
for NODE in $NODES; do
  echo "Checking connectivity to control plane from node $NODE..."
  kubectl exec -it ${POD_NAME} -n ${POD_NAMESPACE} -- ping -c 3 ${CONTROL_PLANE_IP}
done

```

### Resource constraints on the node due to excessive resource utilization by the applications running on it.
```shell

#!/bin/bash

# Set the Kubernetes node name
NODE_NAME=${NODE_NAME}

# Set the resource threshold for CPU utilization
CPU_THRESHOLD=${CPU_THRESHOLD}

# Set the resource threshold for memory utilization
MEMORY_THRESHOLD=${MEMORY_THRESHOLD}

# Get the CPU utilization for the node
CPU_UTILIZATION=$(kubectl top nodes $NODE_NAME | awk 'NR==2{print$2}' | sed 's/%//')

# Get the memory utilization for the node
MEMORY_UTILIZATION=$(kubectl top nodes $NODE_NAME | awk 'NR==2{print$3}' | sed 's/Mi//')

# Check if the CPU utilization is above the threshold
if [ $CPU_UTILIZATION -gt $CPU_THRESHOLD ]; then
  echo "CPU utilization for node $NODE_NAME is above the threshold of $CPU_THRESHOLD%"
fi

# Check if the memory utilization is above the threshold
if [ $MEMORY_UTILIZATION -gt $MEMORY_THRESHOLD ]; then
  echo "Memory utilization for node $NODE_NAME is above the threshold of $MEMORY_THRESHOLD Mi"
fi

```
## Repair
---

### Check the health of the affected Kubernetes node. Identify and fix any underlying issues with the node, such as hardware failure or resource exhaustion.
```shell

#!/bin/bash

# Get the name of the affected Kubernetes node
node_name=${NODE_NAME}

# Check the health of the node
kubectl describe node $node_name | grep -i conditions

# Check the hardware resources of the node
kubectl describe node $node_name | grep -i capacity

# Check the resource utilization of the node
kubectl top node $node_name

# Identify and fix any underlying issues
# Depending on the issue, additional steps may be required here

# Restart the node
kubectl delete node $node_name

```