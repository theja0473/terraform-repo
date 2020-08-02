provider "aws" {
  region     = "${var.region}"
}

resource "aws_instance" "web" {
  ami           = "${var.ami}"
  instance_type = "${var.instace_type}"

  tags = {
    Name = "Sample Instance-1"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo service apache2 start
                EOF
}