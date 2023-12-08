# resource "local_file" "inventory_greenplum" {
#   content = templatefile("./templates/inventory_greenplum.tpl",
#     {
#       ext_ip_vm0 = yandex_compute_instance.pg-0.network_interface.0.nat_ip_address
#     }
#   )
#   filename = "../ansible_greenplum/inventory"
# }
resource "local_file" "inventory_greenplum" {
  content = templatefile("./templates/inventory.tpl",
    {
     ext_ip_vm0 = yandex_compute_instance.pg-0.network_interface.0.nat_ip_address
     ext_ip_vm2 = yandex_compute_instance.pg-2.network_interface.0.nat_ip_address
    }
  )
  filename = "../greenplum.playbook.core/inventory"
}
    #  int_ip_vm1 = yandex_compute_instance.pg-1.network_interface.0.ip_address
    #  int_ip_vm2 = yandex_compute_instance.pg-2.network_interface.0.ip_address
    #  int_ip_vm3 = yandex_compute_instance.pg-3.network_interface.0.ip_address
