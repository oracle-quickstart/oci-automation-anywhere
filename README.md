# oci-automation-anywhere
This is a Terraform module that deploys [Automation Anywhere](https://www.automationanywhere.com) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  It is developed jointly by Oracle and Automation Anywhere.

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

## Clone the Module
You'll first want a local copy of this repo by running:

```
git clone https://github.com/oracle-quickstart/oci-automation-anywhere.git
cd oci-automation-anywhere/
ls
```
That should give you this:

![](./images/01-git_clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

```
terraform init
```
This gives the following output:

![](./images/02-terraform_init.png)

## Deploy

First we want to run `terraform plan`. This runs through the terraform and lists
out the resources to be created based on the values in `variables.tf`. If the
variable doesn't have a default you'll be promted for a value.

If that's good, we can go ahead and apply the deploy:

```
terraform apply
```

You'll need to enter `yes` when prompted.  The apply should take several minutes
to run, and the final setup will happen asynchronously after this returns.

Once complete, you'll see something like this:

![](./images/03-terraform_apply.png)


## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

```
terraform destroy
```

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/04-terraform_destroy.png)
