output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.pg-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.pg-1.network_interface.0.nat_ip_address
}

# output "internal_ip_address_vm_2" {
#   value = yandex_compute_instance.pg-2.network_interface.0.ip_address
# }

# output "external_ip_address_vm_2" {
#   value = yandex_compute_instance.pg-2.network_interface.0.nat_ip_address
# }

# output "id_sec_disk" {
#   value = yandex_compute_disk.disk-2.id
# }
