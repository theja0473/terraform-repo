provider "aws" {
  region     = var.region
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
    Location = "Berlin_VPC"
  }
}


# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.main.id
}
# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}
# Create a subnet to launch our instances into
resource "aws_subnet" "subnet"{
  // count = "${length(data.aws_availability_zones.azs.names)}"
  // availability_zone ="${element(data.aws_availability_zones.azs.names,count.index)}"
  // vpc_id     = "${aws_vpc.main.id}"
  // cidr_block = "${element(var.subnet_cidr,count.index)}"

  availability_zone = var.azs
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    // Name = "Berlin-Subnet-${count.index+1}"
    Name = "Berlin-Subnet-1"
  }
}
# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "md_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  vpc_id      = aws_vpc.main.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = [aws_subnet.subnet.id]
  security_groups = [aws_security_group.md_security_group.id]
  instances       = [aws_instance.md_first_instance.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

// resource "aws_network_interface" "md_network" {
//   subnet_id   = aws_subnet.subnet.id
//   private_ips = ["10.0.1.100"]
//   security_groups = [aws_security_group.md_security_group.id]

//   tags = {
//     Name = "primary_network_interface"
//   }
// }

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "md_first_instance" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    type = "ssh"
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }
  
  ami           = var.ami
  instance_type = var.instace_type
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.default.id]
  key_name = aws_key_pair.deployer.id

  provisioner "remote-exec" {
    // command = "echo ${aws_instance.md_first_instance.public_ip} > ip_address.txt"
    // inline = [
    //   "sudo apt-get -y update",
    //   "sudo apt-get -y install nginx",
    //   "sudo service nginx start",
    // ]
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get install -y docker.io",
      "sudo service docker.io start",
      "sudo docker volume create --name crowdVolume",
      "sudo docker run -v crowdVolume:/var/atlassian/application-data/crowd --name=crowd -d -p 80:8095 atlassian/crowd",
    ]
  }
  tags = {
    Name = "crowd_instance"
  }
}

// resource "aws_network_interface_attachment" "md_network_interface" {
//   instance_id          = aws_instance.md_first_instance.id
//   network_interface_id = aws_network_interface.md_network.id
//   device_index         = 1
// }


// resource "aws_eip" "ip" {
//   instance = aws_instance.md_first_instance.id
//   depends_on = ["aws_instance.md_first_instance"]
// }