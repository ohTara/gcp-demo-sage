resource "google_artifact_registry_repository" "images" {
  project       = var.project_id
  location      = var.region
  repository_id = local.app_name
  format        = "DOCKER"
  description   = "Immagini Docker dell'API Sage"

  depends_on = [google_project_service.apis]
}