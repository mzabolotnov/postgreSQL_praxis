
resource "yandex_compute_instance" "pg-0" {
  name = "pg0"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = "10"
    }
  }
  secondary_disk {
    disk_id = yandex_compute_disk.vdb1.id
    device_name = "gpdata"
  }


  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
# resource "yandex_compute_instance" "pg-1" {
#   name = "pg1"

#   resources {
#     cores  = 2
#     memory = 4
#   }

#   boot_disk {
#     initialize_params {
#       image_id = var.image_id
#       size = "10"
#     }
#   }


#   network_interface {
#     subnet_id = var.subnet_id
#     nat       = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file(var.public_key_path)}"
#   }
# }
resource "yandex_compute_instance" "pg-2" {
  name = "pg2"

  resources {
    cores  = 4
    memory = 16
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = "10"
    }
  }
  secondary_disk {
    disk_id = yandex_compute_disk.vdb2.id
    device_name = "gpdata1"
  }
  secondary_disk {
    disk_id = yandex_compute_disk.vdc1.id
    device_name = "gpdata2"
  }


  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
# resource "yandex_compute_instance" "pg-3" {
#   name = "pg3"

#   resources {
#     cores  = 4
#     memory = 16
#   }

#   boot_disk {
#     initialize_params {
#       image_id = var.image_id
#       size = "50"
#     }
#   }


#   network_interface {
#     subnet_id = var.subnet_id
#     nat       = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file(var.public_key_path)}"
#   }
# }

resource "yandex_compute_disk" "vdb1" {
  name     = "disk-vdb1"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "30"
  image_id = "fd8bbad1kutvs49n1gal"
  labels = {
    environment = "mstgpdata"
  }
}
resource "yandex_compute_disk" "vdb2" {
  name     = "disk-vdb2"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "30"
  image_id = "fd8bbad1kutvs49n1gal"
  labels = {
    environment = "seggpdata"
  }
}

resource "yandex_compute_disk" "vdc1" {
  name     = "disk-vdc1"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "30"
  image_id = "fd8bbad1kutvs49n1gal"
  labels = {
    environment = "seggpdata"
  }
}






