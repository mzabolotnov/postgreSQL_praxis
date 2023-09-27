resource "yandex_compute_disk" "disk-2" {
  name     = "disk-2"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "30"
  image_id = "fd8bbad1kutvs49n1gal"
  # image_id = "fd88fpagiunj098es21f"

  labels = {
    environment = "postgres-data"
  }
}
