## compute/main.tf

data "aws_ami" "proxy_ami" {
  // prebaked AMI with tiny proxy
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["myami-ubuntu-tinyproxy"]
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

resource "random_id" "proxy_ec2_node_id" {
  byte_length = 2
  count       = var.instance_count

  // Generate a new id each time we switch to a new key_name
  // Can do with ami as well 
  keepers = {
    key_name = var.key_name
  }

}

# Request a spot instance at $0.03
resource "aws_spot_instance_request" "proxy_nodes" {
  count         = var.instance_count
  instance_type = "t2.micro"
  subnet_id     = var.public_subnets[count.index]
  ami           = data.aws_ami.proxy_ami.id
  spot_price    = "0.0036"

  tags = {
    Name = "Proxy_node-${random_id.proxy_ec2_node_id[count.index].dec}"
  }

  connection {
    user        = "ubuntu"
    private_key = file("C:/Users/w_yil/OneDrive/Documents/proxy/A4L.ppk")
    host        = self.public_ip
  }

  vpc_security_group_ids = [var.public_sg]

  root_block_device {
    volume_size = var.vol_size
  }
}
