
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