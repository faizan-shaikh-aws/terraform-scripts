resource "local_file" "pets" {
  content         = "We love ${random_pet.name.id} \n and the Private Key is ${tls_private_key.pvt_key.private_key_pem}"
  filename        = "/home/faizan/pets-${random_integer.rand_num.id}.txt"
  file_permission = 0700

  lifecycle {
    create_before_destroy = true
  }

}

resource "random_pet" "name" {
  length    = 1
  prefix    = "Mrs"
  separator = "."

  depends_on = [tls_private_key.pvt_key]


}

resource "tls_private_key" "pvt_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    prevent_destroy = true
  }

}

resource "random_integer" "rand_num" {
  min = 1
  max = 120

  lifecycle {
    ignore_changes = [max]
  }
}

resource "local_file" "hosts_backup" {
  filename = "/home/faizan/hosts_backup"
  content  = "This is just a Backup file \n \n${data.local_file.hosts.content}"
}

data "local_file" "hosts" {
  filename = "/etc/hosts"
}

output "pet_name" {
  value = random_pet.name.id
}

output "private_key" {
  value     = tls_private_key.pvt_key.private_key_pem
  sensitive = true
}

output "rand_int" {
  value = random_integer.rand_num.id
}

