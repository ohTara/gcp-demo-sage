# BigQuery per analytics delle domande (vedi sources/backend/src/sage/integrations/bigquery/question_log.py)
resource "google_bigquery_dataset" "sage_analytics" {
  project    = var.project_id
  dataset_id = var.resource_prefix != "" ? "${replace(var.resource_prefix, "-", "_")}_sage_analytics" : "sage_analytics"
  location   = var.region

  deletion_policy = "DELETE"

  depends_on = [google_project_service.apis]
}

resource "google_bigquery_table" "question_log" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.sage_analytics.dataset_id
  table_id   = "question_log"

  deletion_policy = "DELETE"

  schema = <<EOF
[
  {"name": "question", "type": "STRING", "mode": "REQUIRED"},
  {"name": "sources", "type": "RECORD", "mode": "REPEATED", "fields": [
    {"name": "source", "type": "STRING", "mode": "REQUIRED"},
    {"name": "section", "type": "STRING", "mode": "NULLABLE"},
    {"name": "chunk_index", "type": "INTEGER", "mode": "REQUIRED"}
  ]},
  {"name": "latency_ms", "type": "INTEGER", "mode": "REQUIRED"},
  {"name": "timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"}
]
EOF

  depends_on = [google_bigquery_dataset.sage_analytics]
}