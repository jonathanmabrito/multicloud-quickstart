resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  project       = var.project
  repository_id = var.repoid
  description   = "Genesys container and helm chartrepository"
  format        = "DOCKER"
}
