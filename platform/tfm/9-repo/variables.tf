variable "project" {
    type = string
    description = "Project Name"
}

variable "region" {
    type = string
    description = "GCP Region"
}

variable "repoid" {
    type = string
    description = "The last part of the repository name"
}

variable "repoexists" {
    type = bool
    description = "Pre-run computed value if registry already exists"
}

variable "images" {
    type = set(string)
    default = [
        "hello-world:latest",
        "nginx:alpine",
        "python:alpine3.15"
        ]
}