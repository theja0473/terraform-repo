variable "region" {
    default = "us-east-1"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

// variable "subnet_cidr" {
//     type = "list"
//     default = ["53.23.1.0/24","53.23.2.0/24","53.23.3.0/24","53.23.4.0/24","53.23.5.0/24","53.23.6.0/24"]
// }

// variable "azs" {
//     type = "list"
//     default = ["us-east-1a", "us-east-1b"]
// }

variable "subnet_cidr" {
    default = "10.0.1.0/24"
}

variable "azs" {
    default = "us-east-1a"
}

variable "ami" {
    default = "ami-0ac80df6eff0e70b5"
}

variable "instace_type" {
    default = "t3.micro"
}

// data "aws_availability_zones" "azs" {}

variable "public_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBiI6vW7UBEoQwrPGmEBTAh8yLAlvd8f6MuMTCQowzoEAf4a6Lt5/GhtyEvJP/S3kgODk61c60cScI9PTWdse8xaDElgr57JTvfRKJMeQc8O9qik1UYyZXS4n9TWWyiJFu4FnXe47y2nuhiSytK58/Uyc2jYsbYARBsgGpYsmVw/H3Z1SbNAxY5gA5dj/fkLVoCXOwSwACoGhIm/jFq8Rhqg8BEPm44Krp8KqqS0YRWFTaYHoor9cLvWl0csFDi7H+1URF1UFQ+drTBGN5CAXGEmN8YK19zRu/QWTt/gVuXTKIhU9Gdz4n8tnOjvlQT70EY+LGI2xtGM3yIT5MC4tf admin@localhost.com"
}
variable "key_name" {
  default = "md_first_instance_key"
  description = "Desired name of AWS key pair"
}