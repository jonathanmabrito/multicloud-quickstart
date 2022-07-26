resource "google_artifact_registry_repository" "my-repo" {
  count = var.repoexists ? 1 : 0
  location      = var.region
  project       = var.project
  repository_id = var.repoid
  description   = "Genesys container and helm chart repository"
  format        = "DOCKER"
}

resource "null_resource" "remoteregistry" {
  # Login to remote registry
  provisioner "local-exec" {
    command = "podman login -u ${var.remoteregistry_user} -p ${var.remoteregistry_pass} ${var.remoteregistry}"
  }
}

resource "null_resource" "image" {
  # Pull, tag, push containers
  for_each = var.images
  provisioner "local-exec" {
    command = <<-EOT
      podman pull ${each.value}
      podman tag ${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.value}
      podman push ${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.value}
    EOT
  }
  depends_on = [null_resource.remoteregistry]
}