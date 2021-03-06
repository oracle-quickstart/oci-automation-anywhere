locals {
  # If ad_number is non-negative use it for AD lookup, else use ad_name.
  # Allows for use of ad_number in TF deploys, and ad_name in ORM.
  # Use of max() prevents out of index lookup call.
  ad = var.availability_domain_number >= 0 ? data.oci_identity_availability_domains.availability_domains.availability_domains[max(0, var.availability_domain_number)]["name"] : var.availability_domain_name

  # Platform OL7 image regardless of region
  # This breaks if pegged image removed from the datasource, commenting out for now
  # image datasource unused atm
  # platform_image = data.oci_core_images.ol7.images[0].id

  # Logic to choose platform or mkpl image based on var.enabled
  # Hardcoding due to ^^^
  image = var.mp_listing_resource_id

  # local.use_existing_network defined in network.tf and referenced here
}

resource "oci_core_instance" "a2019" {
  availability_domain = local.ad
  compartment_id      = var.compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.subnet_id : oci_core_subnet.public_subnet[0].id
    display_name     = var.vm_display_name
    assign_public_ip = true
    hostname_label   = "a2019"
    nsg_ids          = [oci_core_network_security_group.nsg.id]
  }

  source_details {
    source_type             = "image"
    source_id               = local.image
    boot_volume_size_in_gbs = 550
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(
      join(
        "\n",
        [
          "#!/usr/bin/env bash",
          "export sql_pw='${var.sql_pw}'",
          "export sql_user='${local.sqldev_enabled == 1 ? "SA" : var.sql_user}'",
          file("./scripts/a2019.sh")
        ]
      )
    )
  }

  extended_metadata = {
    config = jsonencode(
      {
        "sqlserver_ip" = local.sqldev_enabled == 1 ? oci_core_instance.sqlserver-developer[0].private_ip : oci_core_instance.sqlserver-standard[0].private_ip
      },
    )
  }

  depends_on = [
    oci_core_instance.sqlserver-developer[0],
    oci_core_instance.sqlserver-standard[0]
  ]

}

resource "oci_core_instance" "sqlserver-developer" {
  availability_domain = local.ad
  compartment_id      = var.compartment_ocid
  display_name        = "sqlserver"
  shape               = "VM.Standard2.2"
  count               = local.sqldev_enabled

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.subnet_id : oci_core_subnet.public_subnet[0].id
    display_name     = var.vm_display_name
    assign_public_ip = true
    hostname_label   = "sql-developer"
    nsg_ids          = [oci_core_network_security_group.nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = local.image
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(
      join(
        "\n",
        [
          "#!/usr/bin/env bash",
          "export MSSQL_SA_PASSWORD='${var.sql_pw}'",
          file("./scripts/sql_dev.sh")
        ]
      )
    )
  }

}

resource "oci_core_instance" "sqlserver-standard" {
  availability_domain = local.ad
  compartment_id      = var.compartment_ocid
  display_name        = "sqlserver"
  shape               = "VM.Standard2.2"
  count               = local.sql_enabled

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.subnet_id : oci_core_subnet.public_subnet[0].id
    display_name     = var.vm_display_name
    assign_public_ip = true
    hostname_label   = "sql-standard"
    nsg_ids          = [oci_core_network_security_group.nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = var.sql_mp_listing_resource_id
  }

  metadata = {
    user_data = base64encode(join(
      "\n",
      [
        "#ps1_sysnative",
        "$UserName='opc'",
        "$DBUser='${var.sql_user}'",
        "$DBPassword='${var.sql_pw}'",
        "$Password='${var.password}'",
        file("${path.module}/scripts/sqlserver.ps")
    ]))
  }

}
