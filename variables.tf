variable "ussc-adds-ip_address" {
  type    = list(string)
  default = ["10.0.0.68"] # Add more IP addresses to create more domain controllers
}

variable "euw-adds-ip_address" {
  type    = list(string)
  default = ["10.1.0.68"] # Add more IP addresses to create more domain controllers
}
