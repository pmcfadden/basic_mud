provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-1"
}

resource "aws_instance" "mud" {
  ami           = "ami-eca289fb"
  instance_type = "t2.micro"
  subnet_id     = "subnet-3aaa4263"
  associate_public_ip_address = true
  key_name      = "sq2"
}
