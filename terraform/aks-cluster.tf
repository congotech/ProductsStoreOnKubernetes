resource "azurerm_resource_group" "test" {
  name     = "aks-tf-RG"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "test" {
  name                = "aks-tf"
  kubernetes_version  = "1.13.5"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  dns_prefix          = "aks-tf-agent1"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D1_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  service_principal {
    client_id     = "42491d86-af2f-4b58-aab4-e3ae1bdexxxx"
    client_secret = "c741c9c3-c4f1-4c42-a615-fc356e4bxxxx"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.test.kube_config[0].client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.test.kube_config_raw
}
