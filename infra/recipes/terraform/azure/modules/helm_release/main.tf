resource "helm_release" "tables" {
  chart = "tables"
  name = "openhouse-tables-service"
  repository = "../../../../k8s/helm"
  namespace = "application"

  values = ["${file("../../../../k8s/environments/asure/sandbox/tables/values.yaml")}"]

  set {
    name = "storageProperties.containerName"
    value = var.container_name
  }

  set {
    name = "storageProperties.storageAccountName"
    value = var.storage_account_name
  }

  set {
    name = "storageProperties.storageAccountKey"
    value = var.storage_account_key
  }

  set {
    name = "housetables.database.url"
    value = "mysql://${var.db_username}:${var.db_password}@${var.server_name}.mysql.database.azure.com:8080/${var.db_name}"
  }
}