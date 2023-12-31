terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source = "registry.example.com/telmate/proxmox"
      version = ">=1.0.0"
    }
  }
}

provider "proxmox" {
  # Укажите параметры подключения к вашему Proxmox-серверу
  pm_api_url = "https://192.168.88.64:8006/api2/json"
  pm_parallel = "2"
}

# Ресурс форматируется как "[тип]" "[имя_сущности]", так что в данном случае мы собираемся создать сущность proxmox_vm_qemu с именем test_server.
resource "proxmox_vm_qemu" "dc" {
   
  # Пока нужна только одна, можно установить 0 для удаления ВМ.
  count = 2
 
  # count.index начинается с 0, поэтому +1 означает, что эта виртуальная машина будет названа test-vm-1 в Proxmox.
  name = "dc${count.index + 1}"

  # Тип ОС, в примере используется Linux 6.x - 2.6 Kernel
  qemu_os = "l26"
 
  # Теперь происходит обращение к файлу vars. Эта переменная содержит значение "pve"
  target_node = var.proxmox_host
 
  # Эта переменная содержит значение "alse-174-vanilla-template"
  clone = var.template_name

  tags = "aldpro"

  onboot = "true"
 
  # Основные настройки ВМ. Агент относится к гостевому агенту.
  agent = 1
  os_type = "cloud-init"
  cores = 4
  sockets = 1
  cpu = "host"
  memory = 4296
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  vga {
    type = "qxl"
    memory = "16"
  }
  disk {
    slot = 0
    # Установите здесь размер диска. Оставьте его маленьким для тестирования, расширение диска требует времени.
    size = "50G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  # Если вам нужны две сетевые карты, просто скопируйте весь этот сетевой раздел и продублируйте его.
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  # Не совсем уверен, для чего это. Предположительно что-то про MAC-адреса и игнорирование сетевых изменений в течение жизни ВМ.
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  # ${count.index + 1} на пример параметра "name" будет добавлять значение в конец IP-адреса.
  # В этом случае, если мы добавим только одну ВМ, тогда IP-адрес будет 10.98.1.91, где count.index начинается с 0.
  # Таким образом, вы можете создать несколько ВМ с выделенным IP-адресом для каждой (.91, .92, .93, и так далее.).
  ipconfig0 = "ip=10.10.11.3${count.index + 1}/24,gw=10.10.11.1"
   
  # sshkeys использует наш файл vars.tf. Переменная var.ssh_key содержит SSH-ключ.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "dhcp" {
   
  count = 1
  name = "dhcp"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "30G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.20/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "zabbix" {
   
  count = 1
  name = "zabbix"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "30G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.21/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "repo" {
   
  count = 1
  name = "repo"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "100G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.22/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "pxe" {
   
  count = 1
  name = "pxe"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "30G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.23/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "cups" {
   
  count = 1
  name = "cups"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "30G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.24/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "smb" {
   
  count = 1
  name = "smb"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "30G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.25/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "logs" {
   
  count = 1
  name = "logs"
  target_node = var.proxmox_host
  clone = var.template_name
  qemu_os = "l26"
  tags = "aldpro"
  onboot = "true"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "30G"
    type = "scsi"
    storage = "ext4"
    iothread = 0
  }
   
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
 
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ciuser = "u"
  cipassword = "1"
   
  ipconfig0 = "ip=10.10.11.26/24,gw=10.10.11.1"
   
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
