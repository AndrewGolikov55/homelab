variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDafvOll/WJpMl3h3VdIeds1v4KlFsZoR6Ht8DrqYKSDVBqGTkpuozk95imDj57/apXkYgnuE7BvmEmfJrat9pZxF4UUurcb+xHLtShhs266ur8hLI50sFEXry5mLtpGU4/Gb8RYophLJapOi1Y/uQH/3PcC6lt0smaPvyl+9fDoX6VyqqD2eD+EGGp8Phr/bT/WQ0ZmrXZwqpHYzTa1azifrhVvQRGd3F0rtCLY+jc6C2NwfP4d3EA0mRZ+5/o8VNpJ4FgCOWn+kfiTMWHc1ik7malNqBqJ4vMXoo+uJ3IXbidW3EHI8kIKQOo+fSrrNlT3/jdAK7FHHis59Qtj9xF agolikov@vm-automation"
}

# Название вашей ноды в кластере pve
variable "proxmox_host" {
    default = "pve"
}

# Наименование template, который будет использоваться для деплоя ВМ
variable "template_name" {
    default = "alse-vanilla-1.7.3-cloud-max"
}
