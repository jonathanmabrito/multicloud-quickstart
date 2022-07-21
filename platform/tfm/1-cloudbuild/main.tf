# Creating CloudBuild Triggers

resource "google_cloudbuild_trigger" "pe-builder" {
  project = var.project_id
  name = "0-Create-PrivateEdition-Builder"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-builder.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }
}

resource "google_cloudbuild_trigger" "gcp-platform" {
  project = var.project_id
  name = "1-Provision-GCP-Platform"

  source_to_build {
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    ref       = "refs/heads/development"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild-platform.yaml"
    uri       = "https://github.com/jonathanmabrito/multicloud-quickstart"
    revision  = "refs/heads/development"
    repo_type = "GITHUB"
  }

  approval_config {
    approval_required = false
  }
}