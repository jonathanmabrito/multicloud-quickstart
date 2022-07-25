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

variable "remoteregistry" {
    type = string
    description = "Address of remote registry"
}

variable "remoteregistry_user" {
    type = string
    description = "Remote registry user"
}

variable "remoteregistry_pass" {
    type = string
    description = "Remote registry user password"
}

variable "images" {
    type = set(string)
    default = [
        "pureengageuse1-docker-multicloud.jfrog.io/voice/agent_node:100.0.1000013",
        "pureengageuse1-docker-multicloud.jfrog.io/voice/voice_callthread:100.0.1000013",
        "pureengageuse1-docker-multicloud.jfrog.io/voice/voice_config:100.0.1000010"
        ]
}