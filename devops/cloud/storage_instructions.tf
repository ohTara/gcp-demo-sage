# Bucket per le istruzioni aggiuntive (Task 2 verifica)
# Nome: <resource_prefix>instructions (condiviso) o <project_id>-instructions (dedicato)
resource "google_storage_bucket" "instructions" {
  name     = var.resource_prefix != "" ? "${var.resource_prefix}instructions" : "${var.project_id}-instructions"
  project  = var.project_id
  location = var.region

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  force_destroy = true
}