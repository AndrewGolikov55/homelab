variable "ssh_key" {
  default = "ssh-rsa ..."
}

# Название вашей ноды в кластере pve
variable "proxmox_host" {
    default = "pve"
}

# Наименование template, который будет использоваться для деплоя ВМ
variable "template_name" {
    default = "alse-vanilla-1.7.4-cloud-max"
}
