resource "shoreline_notebook" "kubernetes_node_status_not_ok" {
  name       = "kubernetes_node_status_not_ok"
  data       = file("${path.module}/data/kubernetes_node_status_not_ok.json")
  depends_on = [shoreline_action.invoke_connectivity_check,shoreline_action.invoke_resource_threshold_check,shoreline_action.invoke_k8s_node_health_check]
}

resource "shoreline_file" "connectivity_check" {
  name             = "connectivity_check"
  input_file       = "${path.module}/data/connectivity_check.sh"
  md5              = filemd5("${path.module}/data/connectivity_check.sh")
  description      = "Network or connectivity issues between the Kubernetes nodes and the control plane."
  destination_path = "/agent/scripts/connectivity_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "resource_threshold_check" {
  name             = "resource_threshold_check"
  input_file       = "${path.module}/data/resource_threshold_check.sh"
  md5              = filemd5("${path.module}/data/resource_threshold_check.sh")
  description      = "Resource constraints on the node due to excessive resource utilization by the applications running on it."
  destination_path = "/agent/scripts/resource_threshold_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "k8s_node_health_check" {
  name             = "k8s_node_health_check"
  input_file       = "${path.module}/data/k8s_node_health_check.sh"
  md5              = filemd5("${path.module}/data/k8s_node_health_check.sh")
  description      = "Check the health of the affected Kubernetes node. Identify and fix any underlying issues with the node, such as hardware failure or resource exhaustion."
  destination_path = "/agent/scripts/k8s_node_health_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_connectivity_check" {
  name        = "invoke_connectivity_check"
  description = "Network or connectivity issues between the Kubernetes nodes and the control plane."
  command     = "`chmod +x /agent/scripts/connectivity_check.sh && /agent/scripts/connectivity_check.sh`"
  params      = ["POD_NAME","POD_NAMESPACE","CONTROL_PLANE_IP"]
  file_deps   = ["connectivity_check"]
  enabled     = true
  depends_on  = [shoreline_file.connectivity_check]
}

resource "shoreline_action" "invoke_resource_threshold_check" {
  name        = "invoke_resource_threshold_check"
  description = "Resource constraints on the node due to excessive resource utilization by the applications running on it."
  command     = "`chmod +x /agent/scripts/resource_threshold_check.sh && /agent/scripts/resource_threshold_check.sh`"
  params      = ["CPU_THRESHOLD","NODE_NAME","MEMORY_THRESHOLD"]
  file_deps   = ["resource_threshold_check"]
  enabled     = true
  depends_on  = [shoreline_file.resource_threshold_check]
}

resource "shoreline_action" "invoke_k8s_node_health_check" {
  name        = "invoke_k8s_node_health_check"
  description = "Check the health of the affected Kubernetes node. Identify and fix any underlying issues with the node, such as hardware failure or resource exhaustion."
  command     = "`chmod +x /agent/scripts/k8s_node_health_check.sh && /agent/scripts/k8s_node_health_check.sh`"
  params      = ["NODE_NAME"]
  file_deps   = ["k8s_node_health_check"]
  enabled     = true
  depends_on  = [shoreline_file.k8s_node_health_check]
}

