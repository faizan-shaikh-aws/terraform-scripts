variable "az" {
  type = list(string)
  description = "List of Availability Zones"
  default = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f" ]
}

variable "public_subets" {
  type = list(string)
  description = "List of Public Subnets"
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_subnets" {
  description = "List of Private Subnets"
  type = list(string)
  default = [ "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}