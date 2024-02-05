terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

// provide credentials in ENV variables:
// export YC_TOKEN=$(yc iam create-token)
// export YC_CLOUD_ID=$(yc config get cloud-id)
// export YC_FOLDER_ID=$(yc config get folder-id)
provider "yandex" {
  zone = "ru-central1-b"
}

// VM1 2 cores 2GB mem on Ubuntu
resource "yandex_compute_instance" "vm-1" {
 name = "terraform1"

 resources {
   cores  = 2
   memory = 2
 }

 boot_disk {
   initialize_params {
     image_id = "fd81u2vhv3mc49l1ccbb"
   }
 }

 network_interface {
   subnet_id = yandex_vpc_subnet.subnet-1.id
   nat       = true
 }

 metadata = {
   user-data = file("./vm-user.yml")
 }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
