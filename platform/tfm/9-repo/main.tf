resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  project       = var.project
  repository_id = var.repoid
  description   = "Genesys container and helm chart repository"
  format        = "DOCKER"
  lifecycle {
    # Only run if doesn't exists
    precondition {
      condition     = "gcloud artifacts repositories describe ${var.repoid} --location=${var.region}" == 0
      error_message = "Repo already exists"
    }
  }
}



resource "null_resource" "image" {
  # ...
  #interpreter = ["/bin/bash", "-c"]
  for_each = var.images
  provisioner "local-exec" {
    command = <<-EOT
      podman pull docker.io/${each.value}
      podman tag ${each.value} us-west2-docker.pkg.dev/gts-multicloud-pe-dmitry/gts-multicloud-pe/${each.value}
      podman push us-west2-docker.pkg.dev/gts-multicloud-pe-dmitry/gts-multicloud-pe/${each.value}
    EOT
  }
}