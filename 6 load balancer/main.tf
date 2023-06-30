terraform {
  
  required_providers {
    yandex = {
	  source = "yandex-cloud/yandex"
	  version = "0.93.0"
	}
  }
}

provider "yandex" {
  token     = "token"
  cloud_id  = "b1gt5o0vmn0g18hvnuse"
  folder_id = "b1gclm74ejuuquq63ko9"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network_terraform" {
  name = "network_terraform"
}

resource "yandex_vpc_subnet" "subnet_terraform" {
  name           = "subnet_terraform"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}

data "yandex_compute_image" "lamp" {
  family = "lamp"
}

data "yandex_compute_image" "lemp" {
  family = "lemp"
}

resource "yandex_compute_instance" "vm-test1" {
  name                      = "vm-test1"
  allow_stopping_for_update = true
  
  resources {
    cores  = 2
	memory = 2
  }
  
  boot_disk {
    initialize_params {
	  image_id = data.yandex_compute_image.lamp.id
	}
  }
  
  network_interface {
    subnet_id = subnet_terraform.id
	nat       = true
  }
}

resource "yandex_compute_instance" "vm-test2" {
  name                      = "vm-test2"
  allow_stopping_for_update = true
  
  resources {
    cores  = 2
	memory = 2
  }
  
  boot_disk {
    initialize_params {
	  image_id = data.yandex_compute_image.lemp.id
	}
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
	nat = true
  }
}


resource "yandex_lb_network_load_balancer" "lb-test" {
  name = "lb-test"

  listener {
    name = "listener-web-servers"
	port = 80
	external_address_spec {
	  ip_version = "ipv4"
	}
  }
  
  attached_target_group {
    target_group_id = web-servers.id
  }
}

