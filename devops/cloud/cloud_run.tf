resource "google_cloud_run_v2_service" "api" {
  project             = var.project_id
  name                = local.app_name
  location            = var.region
  deletion_protection = false

  template {
    service_account = google_service_account.run.email

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      env {
        name  = "SAGE_PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "SAGE_RESOURCE_PREFIX"
        value = var.resource_prefix
      }
      env {
        name  = "SAGE_REGION"
        value = var.region
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version,
    ]
  }

  depends_on = [
    google_project_service.apis,
    google_project_iam_member.run,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = var.project_id
  location = google_cloud_run_v2_service.api.location
  name     = google_cloud_run_v2_service.api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}