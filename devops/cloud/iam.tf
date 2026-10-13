resource "google_service_account" "run" {
  project      = var.project_id
  account_id   = local.sa_account_id
  display_name = "Sage Cloud Run runtime (${local.app_name})"

  depends_on = [google_project_service.apis]
}

locals {
  run_roles = [
    "roles/datastore.user",
    "roles/aiplatform.user",
    "roles/bigquery.jobUser",
  ]
}

resource "google_project_iam_member" "run" {
  for_each = toset(local.run_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.run.email}"
}