data "aws_availability_zones" "available" {}

resource "aws_vpc" "tfvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "${var.environment_name}-vpc"
    }
}

# Internet GW
resource "aws_internet_gateway" "tfvpc-gw" {
    vpc_id = "${aws_vpc.tfvpc.id}"

    tags {
        Name = "${var.environment_name}"
    }
}

# Subnets
resource "aws_subnet" "tfvpc-public-1" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags {
        Name = "${var.environment_name}-public-1"
    }
}
resource "aws_subnet" "tfvpc-public-2" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags {
        Name = "${var.environment_name}-public-2"
    }
}
resource "aws_subnet" "tfvpc-public-3" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${data.aws_availability_zones.available.names[2]}"

    tags {
        Name = "${var.environment_name}-public-3"
    }
}
resource "aws_subnet" "tfvpc-private-1" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags {
        Name = "${var.environment_name}-private-1"
    }
}
resource "aws_subnet" "tfvpc-private-2" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags {
        Name = "${var.environment_name}-private-2"
    }
}
resource "aws_subnet" "tfvpc-private-3" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${data.aws_availability_zones.available.names[2]}"

    tags {
        Name = "${var.environment_name}-private-3"
    }
}

# route table public
resource "aws_route_table" "tfvpc-public" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.tfvpc-gw.id}"
    }

    tags {
        Name = "${var.environment_name}-route-public-1"
    }
}

# route associations public
resource "aws_route_table_association" "tfvpc-public-1-a" {
    subnet_id = "${aws_subnet.tfvpc-public-1.id}"
    route_table_id = "${aws_route_table.tfvpc-public.id}"
}
resource "aws_route_table_association" "tfvpc-public-2-a" {
    subnet_id = "${aws_subnet.tfvpc-public-2.id}"
    route_table_id = "${aws_route_table.tfvpc-public.id}"
}
resource "aws_route_table_association" "tfvpc-public-3-a" {
    subnet_id = "${aws_subnet.tfvpc-public-3.id}"
    route_table_id = "${aws_route_table.tfvpc-public.id}"
}

# nat gw
resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "tfvpc-nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.tfvpc-public-1.id}"
  depends_on = ["aws_internet_gateway.tfvpc-gw"]
}

# route table private
resource "aws_route_table" "tfvpc-private" {
    vpc_id = "${aws_vpc.tfvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.tfvpc-nat-gw.id}"
    }

    tags {
        Name = "${var.environment_name}-private-1"
    }
}

# route associations private
resource "aws_route_table_association" "tfvpc-private-1-a" {
    subnet_id = "${aws_subnet.tfvpc-private-1.id}"
    route_table_id = "${aws_route_table.tfvpc-private.id}"
}

resource "aws_route_table_association" "tfvpc-private-2-a" {
    subnet_id = "${aws_subnet.tfvpc-private-2.id}"
    route_table_id = "${aws_route_table.tfvpc-private.id}"
}

resource "aws_route_table_association" "tfvpc-private-3-a" {
    subnet_id = "${aws_subnet.tfvpc-private-3.id}"
    route_table_id = "${aws_route_table.tfvpc-private.id}"
}
