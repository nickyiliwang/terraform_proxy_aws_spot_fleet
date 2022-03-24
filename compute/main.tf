## compute/main.tf

data "aws_ami" "proxy_ami" {
  // prebaked AMI with tiny proxy
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-\\d{3}"
  owners           = ["self"]

  filter {
    name   = "source"
    values = ["425237704467/myami-ubuntu-tinyproxy"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "random_id" "tf_ec2_node_id" {
  byte_length = 2
  count       = var.instance_count

  // Generate a new id each time we switch to a new key_name
  // Can do with ami as well 
  keepers = {
    key_name = var.key_name
  }

}

# Request a spot instance at $0.03
resource "aws_spot_instance_request" "cheap_worker" {
  count         = var.instance_count
  instance_type = "t2.micro"
  ami           = data.aws_ami.proxy_ami.id
  spot_price    = "0.0036"

  tags = {
    Name = "Proxy_node"
  }
}
