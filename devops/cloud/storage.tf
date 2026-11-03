# Bucket GCS per i documenti sorgente (PDF, ecc.) caricati per RAG
resource "google_storage_bucket" "sage_docs" {
  project  = var.project_id
  name     = local.docs_bucket_name
  location = var.region

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Nel progetto condiviso ITS distruggere le risorse senza blocchi se viene fatto terraform destroy
  force_destroy = local.shared

  depends_on = [google_project_service.apis]
}
