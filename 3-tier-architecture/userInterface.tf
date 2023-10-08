resource "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Name = "website1_vpc"
  }
}

resource "aws_subnet" "website1Subnet" {
  count = "2"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = ["172.31.1.0/24", "172.31.2.0/24"][count.index]
  tags = {
    Name = "website-1-public"
  }

}

resource "aws_internet_gateway" "website1IG" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "website-1-gateway"
  }
}

resource "aws_lb" "websiteLB" {
  name = "website1-loadbalancer"
  load_balancer_type = "application"
  subnets = "${aws_subnet.website1Subnet.*.id}"
}

resource "aws_instance" "website1"{
  ami = "ami-067d1e60475437da2"
  instance_type = "t2.micro"
  tags = {
    Name = "Website 1"
  }
}