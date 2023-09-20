variable cloud_id{
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-b"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable privat_key_path {
  # Описание переменной
  description = "Path to the privat key used for ssh access"
}
variable service_account_key_file{
  description = "key.json"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet_id"
}

