#Variables declared in this file must be declared in the marketplace.yaml

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

############################
#  Marketplace Image      #
############################

variable "enabled" {
  type    = bool
  default = true
}

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaarynguefvgxywlmm6xxx6ta5semeqizqtkam3zdonpsbsfojvgryq"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaa3fr43xxlmclw7r5na5oazuaaiy7acmtlwrzqor6wszuz4mro6xzq"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "1.0"
  description = "Marketplace Listing Package/Resource Version"
}

############################
#  SQL Configuration   #
############################

variable sql_user {
  default = "aa"
}

variable sql_pw {}

variable password {
  # password for opc user if using paid SQL option
  default = ""
}
variable sql_ip {
  default = "10.0.0.2"
}

variable db_type {
  description = "Understood values: 'SQL Server Developer', 'Existing SQL Server', 'New Paid SQL Server' "
  default = "SQL Server Developer"
}

###
# Paid sql marketplace image info
###

variable sql_mp_listing_id {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaadyirdzoiwya4wt3hqnviqpr4xxhjkm6vzqjd36h2vaoscvwitara"
}
variable sql_mp_listing_resource_id {
  default = "ocid1.image.oc1..aaaaaaaa2zorsxjollcjdq26qijxozek64wv3gvdqf3civlbfwgmc5tpev3a"
}
variable sql_mp_listing_resource_version {
  default = "Microsoft_SQL_2016_Standard_13.0.5366.0-080620192239"
}

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "a2019"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}

variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number" {
  default     = 0
  description = "OCI Availability Domains: 0,1,2  (subject to region availability)"
}

variable "ssh_public_key" {
  description = "SSH Public Key"
}

############################
#  Network Configuration   #
############################

variable "network_strategy" {
  #default = "Use Existing VCN and Subnet"
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "simple-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "simple"
}

variable "subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Use Public Subnet"
}

variable "subnet_span" {
  description = "Choose between regional and AD specific subnets"
  default     = "Regional Subnet"
}

variable "subnet_id" {
  default = ""
}

variable "subnet_display_name" {
  description = "Subnet Name"
  default     = "simple-subnet"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "management"
}

############################
# Additional Configuration #
############################

variable "compartment_ocid" {
  description = "Compartment where infrastructure resources will be created"
}

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "simple-security-group"
}
