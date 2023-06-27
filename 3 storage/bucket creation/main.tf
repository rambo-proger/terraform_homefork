terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.93.0"
    }
  }
}

provider "yandex" {
  token     = "y0_AgAAAAAM4bGSAATuwQAAAADmVhYBksv8ULxcTBC_BGjk4h6dsZacCtk"
  cloud_id  = "b1gt5o0vmn0g18hvnuse"
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

# Создаем сервис-аккаунт SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "sa-skillfactory"
}

# Даем права на запись для этого SA
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создаем ключи доступа Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

# Создаем хранилище
resource "yandex_storage_bucket" "state" {
  bucket     = "tf-state-bucket-mentor-sf"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}