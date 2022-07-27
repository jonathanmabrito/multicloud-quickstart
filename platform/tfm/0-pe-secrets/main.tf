resource "google_secret_manager_secret" "gke-pullsecret-secret" {
  secret_id = "gke-pullsecret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "gke-pullsecret-secret-1" {
  secret      = google_secret_manager_secret.gke-pullsecret-secret.id
  secret_data = google_service_account_key.pullKey.private_key
}