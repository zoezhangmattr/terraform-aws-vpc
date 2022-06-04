variable "name_prefix" {
  type        = string
  description = "a name tag for resources"
  default     = "test"
}
variable "vpc_cidr" {
  type        = string
  default     = "10.240.0.0/16"
  description = "vpc cidr block"
}
variable "public_subnets" {
  default = {
    a = "10.240.0.0/22"
    b = "10.240.4.0/22"
    c = "10.240.8.0/22"
  }
  description = "public subnets map, availability zone map to cidr block"
}

variable "extra_public_subnet_tags" {
  default     = {}
  description = "extra tags to add to public subnet"
}
variable "private_subnets" {
  default = {
    a = "10.240.12.0/22"
    b = "10.240.16.0/22"
    c = "10.240.20.0/22"
  }
  description = "private subnets map, availability zone map to cidr block"
}

variable "extra_private_subnet_tags" {
  default     = {}
  description = "extra tags to add to private subnet"
}

variable "natgateway" {
  default     = ["a", "b", "c"]
  description = "nat gateway list of availability zone to spread"
}
