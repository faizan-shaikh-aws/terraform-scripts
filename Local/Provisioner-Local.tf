resource "local_file" "hadoop" {
  filename = "/home/faizan/hadoop"
  #content = data.local_file.resolv.content
  content = file("/etc/nsswitch.conf")


  provisioner "local-exec" {
    command = "cat ${local_file.hadoop.filename}"
  }

}

data "local_file" "resolv" {
  filename = "/etc/resolv.conf"
}

/********** Destroy **********/

resource "local_file" "hadoop" {
  filename = "/home/faizan/hadoop"
  content  = file("/etc/resolv.conf")

  provisioner "local-exec" {
    when    = destroy
    command = "cp ${self.filename} /tmp/backup.conf"
  }
}
