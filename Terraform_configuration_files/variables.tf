variable "REGION" {
  type = string
}

variable "VPC_CIDR" {
  type = string
}

variable "SUBNET_TAGNAMES" {
  type = list(string)
}

variable "ROUTE_NAMES" {
  type = list(string)
}

variable "AVAILABILITY_ZONE_NAMES" {
  type = list(string)
}

variable "WEB_TRIGGERS" {
  type = string
}