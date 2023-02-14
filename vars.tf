variable "cidr_block" {
  type    = string
  default = "10.10.0.0/16"
}

variable "private_subnets" {
  default = [
    "10.10.10.0/24"
  ]
}

variable "public_subnets" {
  default = [
    "10.10.110.0/24"
  ]
}

variable "env_name" {
  type    = string
  default = "insolent-ichthyosaur"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "container_image" {
  type    = string
  default = "crccheck/hello-world"
}
