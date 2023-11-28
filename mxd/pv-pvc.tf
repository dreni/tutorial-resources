# add a persistent volume to the postgres deployment that points to a local folder /Users/Shared/k8s-pg-data
resource "kubernetes_persistent_volume" "pg-pv" {
    metadata {
        name = "pg-pv"
    }
    spec {
        capacity = {
            storage = "2Gi"
        }
        access_modes = ["ReadWriteMany"]
        storage_class_name = "standard" 

        persistent_volume_source {
            host_path {
                path = "/pg-data/"
            }
        }
        persistent_volume_reclaim_policy = "Retain"
    }
}

# add persistent volume claim to the postgres deployment
resource "kubernetes_persistent_volume_claim" "pg-pvc" {
  metadata {
    name = "pg-pvc"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.pg-pv.metadata.0.name
    storage_class_name = "standard" 
  }
}