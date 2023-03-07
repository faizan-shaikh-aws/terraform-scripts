variable "filenames" {
  type    = list(string)
  default = ["/home/faizan/1.txt", "/home/faizan/2.txt", "/home/faizan/3.txt"]
}

resource "local_file" "demo" {

  filename = var.filenames[count.index]
  content  = "Hello World - ${count.index}"

  count = length(var.filenames)



}

output "getVal" {
  value = "${local_file.demo[0].id}\n${local_file.demo[1].id}\n${local_file.demo[2].id}"

}

/****** Output 

local_file.demo[1]: Creation complete after 0s [id=d46aa42c0e64aec081fa8b6ec082bdf6ca1283be]
local_file.demo[2]: Creation complete after 0s [id=80b50a9e206504725ff7972b5411ce942996e583]
local_file.demo[0]: Creation complete after 0s [id=00af9d646414fe539383088111f9b1abf9a59239]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

getVal = <<EOT
00af9d646414fe539383088111f9b1abf9a59239
d46aa42c0e64aec081fa8b6ec082bdf6ca1283be
80b50a9e206504725ff7972b5411ce942996e583
EOT
******/