// Output the IDs of the ECS instances created
output "instance_ids" {
  value = "${join(",", alicloud_instance.instances.*.id)}"
}

// Output the IDs of the ECS disks created
output "disk_ids" {
  value = "${join(",", alicloud_disk.disks.*.id)}"
}

// Output the IDs of the security group in specific vpc
output "security-groups-in vpc" {
  value = "${data.alicloud_security_groups.group.groups.0.id}"
}

// Output the IDs of the security group in specific vpc
output "vpcs" {
  //value = "${join(",", data.alicloud_vpcs.mul_vpc.*.vpc_name)}"
  value = "${data.alicloud_vpcs.mul_vpc.vpcs.0.vpc_name}"
}