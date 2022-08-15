variable "tag_name" {
   default = "lab7-vpc"
}

variable "vpc-cidr" {
   default = "10.1.0.0/16"
}

variable "labname" {
   description = "prefix for lab resources"
   default = "lab7"
}

#map to create subnets : usw2 = US-WEST-2 (oregon) and this is followed by the desired AZ ie az1
variable "prefix" {
   type = map
   default = {
      sub-1 = {
         az = "usw2-az1"
         cidr = "10.1.0.0/24"
      }
      sub-2 = {
         az = "usw2-az2"
         cidr = "10.2.0.0/24"
      }
      sub-3 = {
         az = "usw2-az3"
         cidr = "10.3.0.0/24"
      }
     
   }
}

variable "prefix2" {
   type = map
   default = {
      sub-1 = {
         az = "usw2-az1"
         cidr = "10.4.0.0/24"
      }
      sub-2 = {
         az = "usw2-az2"
         cidr = "10.5.0.0/24"
      }
      sub-3 = {
         az = "usw2-az3"
         cidr = "10.6.0.0/24"
      }
     
   }
}