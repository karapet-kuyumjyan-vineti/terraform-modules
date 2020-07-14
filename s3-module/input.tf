#================
#Global Variables
#================

variable "client_name" {
  type = string
  default = "epam-barb"
}

variable "primary_region" {
  type = string
  default = "us-east-1"
}

variable "dr_region" {
  type = string
  default = "us-west-1"
}

variable "env" {
  type = string
  default = "demo-01"
}