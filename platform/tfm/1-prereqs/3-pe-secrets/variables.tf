variable "region" {
    type = string
    description = "GCP Region"
}

variable "GAUTH_POSTGRES_PASSWORD" {
    type = string
    description = "Password GAUTH Service and POSTGRES_PASSWORD"
}

variable "GAUTH_gauth_pg_password" {
    type = string
    description = "Password GAUTH Service and gauth_pg_password"
}