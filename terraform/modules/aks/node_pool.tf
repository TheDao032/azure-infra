resource "azurerm_kubernetes_cluster_node_pool" "main" {
  name                         = "${var.user_node_pool_name}${var.env}"
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.main.id
  vm_size                      = var.user_node_pool_vm_size
  mode                         = var.mode
  node_labels                  = var.node_labels
  node_taints                  = var.node_taints
  zones                        = var.user_node_pool_availability_zones
  vnet_subnet_id               = var.aks_user_subnet_id
  pod_subnet_id                = var.pod_subnet_id
  enable_auto_scaling          = var.user_node_pool_enable_auto_scaling
  enable_host_encryption       = var.user_node_pool_enable_host_encryption
  enable_node_public_ip        = var.user_node_pool_enable_node_public_ip
  proximity_placement_group_id = var.proximity_placement_group_id
  orchestrator_version         = var.orchestrator_version
  max_pods                     = var.user_node_pool_max_pods
  max_count                    = var.user_node_pool_max_count
  min_count                    = var.user_node_pool_min_count
  node_count                   = var.user_node_pool_node_count
  os_disk_size_gb              = var.user_node_pool_os_disk_size_gb
  os_disk_type                 = var.user_node_pool_os_disk_type
  os_type                      = var.user_node_pool_os_type
  priority                     = var.priority
  tags                         = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      node_count
    ]
  }

  depends_on = [azurerm_kubernetes_cluster.main]
}
