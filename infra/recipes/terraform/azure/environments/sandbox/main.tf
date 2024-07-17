resource "azurerm_resource_group" "openhouse_sandbox" {
    name = var.resource_group_name
    location = var.resource_group_location
}

resource "random_string" "storage_name" {
    length = 5
    special = false
    lower = true
    upper = false
}

locals {
    storage_account_name = "openhousestorage${random_string.storage_name.result}" // added random string of numbers to make it unique
    container_name = "blobcontainer"
    db_username = "azureadmin"
    db_password = "Pa33word"
    db_name = "openhouse-sandbox-db"
    db_server_name = "openhouse-sandbox-mysql-server"
}

module "vm" {
    source = "../../modules/vm"
    depends_on = [ azurerm_resource_group.openhouse_sandbox ]
    virtual_network_name = "openhouse-sandbox-network"
    resource_group_name = var.resource_group_name
    subnet_name = "openhouse-sandbox-subnet"
}

module "mysql" {
    source = "../../modules/mysql"
    depends_on = [ module.vm ]
    subnet_id = module.vm.subnet_id
    resource_group_name = azurerm_resource_group.openhouse_sandbox.name
    server_name = local.db_server_name
    db_admin_login = local.db_username
    db_admin_password = local.db_password
    db_name = local.db_name
}

module "k8s" {
  source = "../../modules/k8s"
  depends_on = [ azurerm_resource_group.openhouse_sandbox ]
  resource_group_name = azurerm_resource_group.openhouse_sandbox.name
  node_count = 1
  vm_size = "Standard_D2s_v3"
}

module "storage" {
    source = "../../modules/storage"
    depends_on = [ azurerm_resource_group.openhouse_sandbox ]
    storage_account_name = local.storage_account_name
    resource_group_name = azurerm_resource_group.openhouse_sandbox.name
    container_name = local.container_name
}

data "azurerm_storage_account" "default" {
    depends_on = [ module.storage ]
    resource_group_name = var.resource_group_name
    name = local.storage_account_name
}

module "helm_release" {
    source = "../../modules/helm_release"
    depends_on = [ module.k8s, module.storage, module.mysql ] // so k8s cluster is instantiated before helm deployment
    storage_account_name = local.storage_account_name
    storage_account_key = data.azurerm_storage_account.default.primary_access_key
    container_name = local.container_name
    db_username = local.db_username
    db_password = local.db_password
    db_name = local.db_name
    server_name = local.db_server_name
}