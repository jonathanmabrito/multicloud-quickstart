resource "google_service_account" "gke-pullsecret" {
  account_id   = "gke-pullsecret"
  description  = "Pull Secret for Artifact and Container images"
  display_name = "gke-pullsecret"
  project      = var.project
}

resource "google_project_iam_member" "project_viewer" {
  project = var.project
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.gke-pullsecret.email}"
}

resource "google_project_iam_member" "artifact_writer" {
  project = var.project
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.gke-pullsecret.email}"
}

resource "google_service_account_key" "pullKey" {
  service_account_id = google_service_account.gke-pullsecret.name
}

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