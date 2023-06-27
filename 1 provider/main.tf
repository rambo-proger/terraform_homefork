variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Use specific availability zone"
}


terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.93.0"
    }
  }
}

locals {
  folder_id = "b1gclm74ejuuquq63ko9"
  cloud_id = "b1gt5o0vmn0g18hvnuse"
}

provider "yandex" {
  # Configuration options
  cloud_id = local.cloud_id
  folder_id = local.folder_id
  service_account_key_file = "C:\\terraform\\key\\authorized_key.json"
  zone = var.zone
}

