resource "google_bigquery_dataset" "analytics" {
  project                    = var.project_id
  dataset_id                 = local.bigquery_dataset_id
  location                   = var.region
  delete_contents_on_destroy = true

  depends_on = [google_project_service.apis]
}

resource "google_bigquery_table" "question_log" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.analytics.dataset_id
  table_id            = "question_log"
  deletion_protection = false

  schema = jsonencode([
    { name = "timestamp", type = "TIMESTAMP", mode = "REQUIRED" },
    { name = "question", type = "STRING", mode = "REQUIRED" },
    { name = "sources_count", type = "INTEGER", mode = "NULLABLE" },
    { name = "latency_ms", type = "INTEGER", mode = "NULLABLE" },
  ])
}

resource "google_bigquery_dataset_iam_member" "run_editor" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.run.email}"
}