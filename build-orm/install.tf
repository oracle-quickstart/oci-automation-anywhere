variable "save_to" {
    default = ""
}

data "archive_file" "generate_zip" {
  type        = "zip"
  output_path = (var.save_to != "" ? "${var.save_to}/orm.zip" : "${path.module}/dist/orm.zip")
  source_dir = "../"
  excludes    = ["images", ".git", ".gitignore", "README.md", "LICENSE", "build-orm", "scratch", "terraform.tfstate", "terraform.tfstate.backup", "terraform.tfvars.template", "terraform.tfvars", "provider.tf", ".terraform"]
}
