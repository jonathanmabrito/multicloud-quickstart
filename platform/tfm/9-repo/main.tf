resource "google_artifact_registry_repository" "my-repo" {
  count = var.repoexists ? 1 : 0
  location      = var.region
  project       = var.project
  repository_id = var.repoid
  description   = "Genesys container and helm chart repository"
  format        = "DOCKER"
}

resource "null_resource" "remoteregistrylogin" {
  # Login to remote registry
  provisioner "local-exec" {
    command = "podman login -u ${var.remoteregistry_user} -p ${var.remoteregistry_pass} ${var.remoteregistry}"
  }
}

resource "null_resource" "image-pull" {
  # Pullcontainers
  for_each = var.images
  provisioner "local-exec" {
    command = "podman pull ${var.remoteregistry}/${each.value}"
  }
  depends_on = [null_resource.remoteregistrylogin]
}

resource "null_resource" "image-tag" {
  # Tag containers
  for_each = var.images
  provisioner "local-exec" {
    command = "podman tag ${var.remoteregistry}/${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.value}"
  }
  depends_on = [null_resource.image-pull]
}

resource "null_resource" "image-push" {
  # Push containers
  for_each = var.images
  provisioner "local-exec" {
    command = "podman push ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.value}"
  }
  depends_on = [null_resource.image-tag]
}