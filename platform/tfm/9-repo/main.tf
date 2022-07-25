#resource "google_artifact_registry_repository" "my-repo" {
#  location      = var.region
#  project       = var.project
#  repository_id = var.repoid
#  description   = "Genesys container and helm chart repository"
#  format        = "DOCKER"
#}

resource "null_resource" "image" {
  # ...

  provisioner "local-exec" {
    command = "podman pull docker.io/library/hello-world:latest | podman tag docker.io/library/hello-world:latest us-west2-docker.pkg.dev/gts-multicloud-pe-dmitry/gts-multicloud-pe/hello-world | podman push us-west2-docker.pkg.dev/gts-multicloud-pe-dmitry/gts-multicloud-pe/hello-world:latest"
  }
}