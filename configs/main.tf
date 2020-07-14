module "s3" {
  source = "../s3-module"

  primary_region = "us-east-1"
  dr_region = "us-west-2"

  client_name = "epam-mach1"

  env = "demo-02"
}
