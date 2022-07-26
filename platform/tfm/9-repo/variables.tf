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
        #"voice/agent_node:100.0.1000013",
        #"voice/callthread_node:100.0.1000013",
        #"voice/config_node:100.0.1000010"
        ]
}

variable "charts" {
    type = map
    default = {
        "voice-agent" = "100.0.1000005"
        "voice-callthread" = "100.0.1000006"
        "voice-config" = "100.0.1000004"
        "voice-dialplan" = "100.0.1000007"
        "voice-ors" = "100.0.1000018"
        "voice-registrar" = "100.0.1000007"
        "voice-rq" = "100.0.1000004"
        "voice-sip" = "100.0.1000017"
        "voice-sipfe" = "100.0.1000006"
        "voice-sipproxy" = "100.0.1000004"
        "voice-voicemail" = "100.0.1000012"
    }
}