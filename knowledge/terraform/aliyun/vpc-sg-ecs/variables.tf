# common variables
variable "alicloud_access_key" {
  description = "The Alicloud Access Key ID to launch resources."
  default = "*********"
}
variable "alicloud_secret_key" {
  description = "The Alicloud Access Secret Key to launch resources."
  default = "************"
}
variable "region" {
  description = "The region to launch resources."
  default = "cn-huhehaote"
}
variable "availability_zone" {
  description = "The available zone to launch ecs instance and other resources."
  default = "cn-huhehaote-a"
}
variable "number_format" {
  description = "The number format used to output."
  default = "%02d"
}

# Image variables
variable "image_name_regex" {
  description = "The ECS image's name regex used to fetch specified image."
  //default = "^ubuntu_14.*_64"
  default = "centos_7_04_64_20G_alibase_201701015.vhd"
}

# Instance typs variables
variable "cpu_core_count" {
  description = "CPU core count used to fetch instance types."
  //default = 8
  default = 1
}

variable "memory_size" {
  description = "Memory size used to fetch instance types."
  //default = 60
  default = 2
}

# VSwitch  ID
//variable "vswitch_id" {
  //description = "The vswitch id used to launch one or more instances."
  //default = "vsw-hp35nicv1bihx79i4ew8l" //ram
//}

# VPC variables
//variable "vpc_id" {
  //description = "The vpc id used to launch several vswitches."
  //default = "vpc-hp3nek0jbrc9te258h9sq"
  //default = "vpc-hp358mg9i4v3y2l8z5mzs"  //ram
//}

variable "vpc_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  default = "TF-VPC"
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  default = "172.16.0.0/12"
}
variable "vswitch_cidrs" {
  description = "The cidr blocks used to launch several new vswitches."
  default = "172.16.0.0/24"
}
# Security Group variables
//variable "group_ids" {
  //description = "List of security group ids used to join ECS instances."
  //type = "list"
  //default = ["sg-hp3d0vaqm4hlpbtj53s4"]
  //default = ["sg-hp3byz3ieo47w617dqgw"]
//}

# Key pair variables
variable "key_name" {
  description = "The key pair name used to attach one or more instances."
  default = ""
}

# Disk variables
variable "disk_name" {
  description = "The data disk name used to mark one or more data disks."
  default = "TF_ECS_Disk"
}

variable "disk_category" {
  description = "The data disk category used to launch one or more data disks."
  default = "cloud_efficiency"
}

variable "disk_size" {
  description = "The data disk size used to launch one or more data disks."
  default = "60"
}

variable "disk_tags" {
  description = "Used to mark specified ecs data disks."
  type = "map"
  default = {
    created_by = "Terraform"
    created_from = "module-tf-alicloud-ecs-instance"
  }
}

variable "number_of_disks" {
  description = "The number of launching disks one time."
  default = 1
}

# Ecs instance variables
variable "image_id" {
  description = "The image id used to launch one or more ecs instances."
  default = ""
}
variable "instance_type" {
  description = "The instance type used to launch one or more ecs instances."
  default = "ecs.xn4.small"
  //default = "ecs.gn5-c8g1.2xlarge"
}
variable "system_category" {
  description = "The system disk category used to launch one or more ecs instances."
  default = "cloud_efficiency"
}
variable "system_size" {
  description = "The system disk size used to launch one or more ecs instances."
  //default = "40"
  default = "50"
}
variable "instance_name" {
  description = "The instance name used to mark one or more instances."
  default = "TF-ECS-Instance-by-leo"
}

variable "host_name" {
  description = "The instance host name used to configure one or more instances.."
  default = "leo-alicloud"
}

variable "password" {
  description = "The password of instance."
  default = "123456a?"
}

variable "allocate_public_ip" {
  description = "Default to allocate public ip for new instances."
  default = true
}

variable "internet_charge_type" {
  description = "The internet charge type of instance. Choices are 'PayByTraffic' and 'PayByBandwidth'."
  default = "PayByTraffic"
}

variable "internet_max_bandwidth_out" {
  description = "The maximum internet out bandwidth of instance.."
  default = 10
}

variable "instance_charge_type" {
  description = "The charge type of instance. Choices are 'PostPaid' and 'PrePaid'."
  default = "PostPaid"
}

variable "period" {
  description = "The period of instance when instance charge type is 'PrePaid'."
  default = 1
}

variable "instance_tags" {
  description = "Used to mark specified ecs instance."
  type = "map"
  default = {
    created_by = "Terraform"
    created_from = "module-tf-alicloud-ecs-instance"
  }
}

variable "number_of_instances" {
  description = "The number of launching instances one time."
  default = 1
}