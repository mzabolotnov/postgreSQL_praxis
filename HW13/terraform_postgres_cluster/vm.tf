
resource "yandex_compute_instance" "pg-1" {
  name = "pg1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = "20"
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.bar.id
    # subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}







