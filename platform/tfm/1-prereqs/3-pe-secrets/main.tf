resource "google_secret_manager_secret" "GAUTH_POSTGRES_PASSWORD-secret" {
  secret_id = "GAUTH_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_POSTGRES_PASSWORD-secret.id
  secret_data = var.GAUTH_POSTGRES_PASSWORD
}


resource "google_secret_manager_secret" "GAUTH_gauth_pg_password-secret" {
  secret_id = "GAUTH_gauth_pg_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_gauth_pg_password-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_gauth_pg_password-secret.id
  secret_data = var.GAUTH_gauth_pg_password
}