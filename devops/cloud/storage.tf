resource "google_storage_bucket" "docs" {
  project                     = var.project_id
  name                        = local.docs_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true

  depends_on = [google_project_service.apis]
}

resource "google_storage_bucket_iam_member" "run_docs_reader" {
  bucket = google_storage_bucket.docs.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.run.email}"
}