variable "ports_ec2_public" {
  type = list(number)
  default = ["22","443","80"]
}
variable "ports_ec2_private" {
  type = list(number)
  default = ["22","3110"]
}

