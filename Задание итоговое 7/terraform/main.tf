terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.65.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = file("~/ansible.json")
  cloud_id                 = "ansible"
  folder_id                = "b1g47cmuasifjjhsj7ah"
  zone                     = "ru-central1-a"
}

variable "vm_count" {
  description = "Количество виртуальных машин"
  type        = number
  default     = 5
}

variable "os_list" {
  description = "Список операционных систем для виртуальных машин"
  type        = list(string)
  default     = ["ubuntu", "centos"] // Список доступных операционных систем
}

variable "folder_id" {
  description = "ID папки, где будут создаваться виртуальные машины"
  type        = string
  default     = "b1g47cmuasifjjhsj7ah"
}

data "yandex_compute_image" "available_images" {
  for_each = toset(var.os_list)
  family   = each.value == "ubuntu" ? "ubuntu-2204-lts" : each.value == "centos" ? "centos-stream-8" : null
}

resource "yandex_vpc_network" "network" {
  name      = "my-network"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "internal_subnet" {
  count      = var.vm_count
  name       = "internal-subnet-${count.index}"
  folder_id  = var.folder_id
  zone       = "ru-central1-a"
  network_id = yandex_vpc_network.network.id
  v4_cidr_blocks = [
    "192.168.${10 + count.index}.0/24",
  ]
}

resource "yandex_compute_instance" "vms" {
  count                     = var.vm_count * length(var.os_list)
  name                      = "vm-${count.index}"
  zone                      = "ru-central1-a"
  hostname                  = "vm-${count.index}" // Используем имя виртуальной машины в качестве хоста
  allow_stopping_for_update = true
  platform_id               = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.available_images[var.os_list[(count.index % length(var.os_list))]].id
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal_subnet[count.index / length(var.os_list)].id
    nat       = true
  }

  metadata = {
 #   ssh-keys = "login:${file("/path/to/public_key_file.pub")}"
    user-data = "${file("/home/avolon/docker/projact7/terraform/cloud-config")}"
    serial-port-enable = "1"
  }

  scheduling_policy {
    preemptible = true
  }
}
