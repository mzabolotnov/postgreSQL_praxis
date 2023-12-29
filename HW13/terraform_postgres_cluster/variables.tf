variable "network_id" {
  description = "PostgreSQL cluster network id"
  type        = string
}
variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  default     = "ru-central1-a"
}
variable public_key_path {
  default = "~/.ssh/appuser.pub"
}
variable service_account_key_file {
  description = "key.json"
}
variable image_id {
  description = "Disk image"
}