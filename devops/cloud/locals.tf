locals {
  # Progetto condiviso = c'è un prefisso
  shared = var.resource_prefix != ""

  # Cloud Run e Artifact Registry
  app_name = local.shared ? "${var.resource_prefix}-sage" : "sage"

  # Bucket dei documenti sorgente
  docs_bucket_name = local.shared ? "${var.resource_prefix}-sage-docs" : "${var.project_id}-sage-docs"

  # Firestore: un solo (default) per progetto, quindi in condiviso un database per persona
  firestore_database_name = local.shared ? var.resource_prefix : "(default)"

  # BigQuery: i dataset non ammettono trattini
  bigquery_dataset_id = local.shared ? "${replace(var.resource_prefix, "-", "_")}_sage_analytics" : "sage_analytics"

  # Service account: massimo 30 caratteri, se serve accorciamo e aggiungiamo un hash
  sa_account_id_full = local.shared ? "${var.resource_prefix}-sage-run" : "sage-run"
  sa_account_id = (
    length(local.sa_account_id_full) <= 30
    ? local.sa_account_id_full
    : "${substr(var.resource_prefix, 0, 16)}-${substr(sha1(var.resource_prefix), 0, 4)}-sage-run"
  )
}