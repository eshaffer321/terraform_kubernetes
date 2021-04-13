output "crypto_key_name" {
  value = google_kms_crypto_key.crypto_key.name
}

output "key_ring_name" {
  value = google_kms_key_ring.key_ring.name
}

output "kms_region" {
  value = google_kms_key_ring.key_ring.location
}