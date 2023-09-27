
resource "yandex_compute_instance" "pg-1" {
  name = "pg1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.disk-2.id
    device_name = "pgdata"
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

resource "yandex_compute_instance" "pg-2" {
  name = "pg2"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }



  # secondary_disk {
  #   disk_id = yandex_compute_disk.disk-2.id
  #   device_name = "pgdata"
  # }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}



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



