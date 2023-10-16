resource "yandex_lb_network_load_balancer" "patroni" {
  name = "patroni-load-balancer"

  listener {
    name = "patroni-listener-rw"
    port = 5000
    protocol = "tcp"
    target_port = 5000
    external_address_spec {
      ip_version = "ipv4"
    }
  }
    listener {
    name = "patroni-listener-r"
    port = 5001
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.patroni.id}"

    healthcheck {
      name = "tcp"
      tcp_options {
        port = 5000
      }
    }
  }
}
