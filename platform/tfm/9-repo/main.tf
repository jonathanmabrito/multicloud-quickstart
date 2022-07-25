resource "google_artifact_registry_repository" "my-repo" {
  count = var.repoexists ? 1 : 0
  location      = var.region
  project       = var.project
  repository_id = var.repoid
  description   = "Genesys container and helm chart repository"
  format        = "DOCKER"
  #lifecycle {
    # Only run if doesn't exists
  #  precondition {
  #    condition     = "gcloud artifacts repositories describe ${var.repoid} --location=${var.region}" == 0
  #    error_message = "Repo already exists"
  #  }
  #}
}



resource "null_resource" "image" {
  # ...
  #interpreter = ["/bin/bash", "-c"]
  for_each = var.images
  provisioner "local-exec" {
    command = <<-EOT
      podman pull docker.io/${each.value}
      podman tag ${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.value}
      podman push ${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.value}
    EOT
  }
}