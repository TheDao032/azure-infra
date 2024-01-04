locals {
  sql_files = fileset(var.sql_dir, "*.sql")
}

resource "azurerm_postgresql_database" "main" {
  for_each            = local.sql_files
  name                = split(".sql", each.value)[0]
  resource_group_name = var.deployment_resource_group_name
  server_name         = var.db_server_name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = var.secrets["jumpboxAgentUsername"]
      password = var.secrets["jumpboxAgentPassword"]
      host     = var.provisioner_host
    }

    inline = [
      "export DEBIAN_FRONTEND=noneinteractive",
      "sudo dpkg --configure -a",
      "sudo mkdir /var/log/db-init /var/log/db-init/${var.env}",
      "echo \"${templatefile("${var.sql_dir}/${each.value}", var.secrets)}\" > ${each.value}",
      "PGPASSWORD=\"${var.db_master_password}\" psql -U ${var.db_master_username}@${var.db_server_name} -h ${var.db_host} -d ${var.db_master_name} -f ${each.value} 2>&1 | sudo tee -a /var/log/db-init/${var.env}/${each.value}.log /var/log/db-init/${var.env}/db-init.log",
      "rm -f ${each.value}"
    ]
    on_failure = fail
  }

  # prevent the possibility of accidental data loss
  # lifecycle {
  #   prevent_destroy = true
  # }
}
