variable "region" {
  description = "location to build resources"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "size of VM"
  type        = string
  default     = "t2.micro"
}

variable "az_count" {
  default     = 3
}