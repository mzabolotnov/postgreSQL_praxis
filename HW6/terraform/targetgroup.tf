resource "yandex_lb_target_group" "patroni" {
  name      = "patroni-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = var.subnet_id
    address   = "${yandex_compute_instance.pg-1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = var.subnet_id
    address   = "${yandex_compute_instance.pg-2.network_interface.0.ip_address}"
  }
  target {
    subnet_id = var.subnet_id
    address   = "${yandex_compute_instance.pg-3.network_interface.0.ip_address}"
  }

}
