resource "local_file" "hosts_cfg" {
  content = templatefile("./templates/inventory.tpl",
    {
     ext_ip_vm1 = yandex_compute_instance.pg-1.network_interface.0.nat_ip_address
     ext_ip_vm2 = yandex_compute_instance.pg-2.network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/inventory"
}

# data  "template_file" "inv-yc" {
#     template = "${file("./templates/inventory.tpl")}"
#     vars {
#      ext_ip_vm1 = "${join("\n", yandex_compute_instance.pg-1.network_interface.0.nat_ip_address)}",
#      ext_ip_vm2 = "${join("\n", yandex_compute_instance.pg-2.network_interface.0.nat_ip_address)}"
# }
    
# }

# resource "local_file" "k8s_file" {
#   content  = "${data.template_file.inv-yc.rendered}"
#   filename = "../ansible/inventory"
# }