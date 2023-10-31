resource "local_file" "hosts_cfg" {
  content = templatefile("./templates/inventory.tpl",
    {
     ext_ip_vm1 = yandex_compute_instance.pg-1.network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/inventory"
}

