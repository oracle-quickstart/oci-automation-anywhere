###
# compute.tf outputs
###

output "a2019_public_ip" {
  value = oci_core_instance.a2019.public_ip
}

output "a2019_private_ip" {
  value = oci_core_instance.a2019.private_ip
}

output "a2019_https_url" {
  value = "https://${oci_core_instance.a2019.public_ip}"
}

###
# network.tf outputs
###

output "vcn_id" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.vcn.*.id) : var.vcn_id
}

output "subnet_id" {
  value = ! local.use_existing_network ? join("", oci_core_subnet.public_subnet.*.id) : var.subnet_id
}

output "vcn_cidr_block" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.vcn.*.cidr_block) : var.vcn_cidr_block
}

output "nsg_id" {
  value = join("", oci_core_network_security_group.nsg.*.id)
}

###
# image_subscription.tf outputs
###

output "subscription" {
  value = data.oci_core_app_catalog_subscriptions.mp_image_subscription.*.app_catalog_subscriptions
}
