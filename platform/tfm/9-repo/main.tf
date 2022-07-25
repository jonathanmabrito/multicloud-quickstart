#resource "google_artifact_registry_repository" "my-repo" {
#  location      = var.region
#  project       = var.project
#  repository_id = var.repoid
#  description   = "Genesys container and helm chart repository"
#  format        = "DOCKER"
#}

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