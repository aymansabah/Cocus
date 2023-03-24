
# Security Groups and EC2s

# Create Public Security Group and specify in/out bound rules
resource "aws_security_group" "Ec2-public-SG" {
  vpc_id = aws_vpc.awslab-vpc.id
  name = "EC2-public-SG"
  description = "Ec2 instances public SG"
  dynamic "ingress" {
  for_each = var.ports_ec2_public
  iterator = port
  content {
    from_port = port.value
    to_port = port.value
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ec2 instances public SG"
  }
  }
  ingress {
protocol = "icmp"
cidr_blocks = ["0.0.0.0/0"]
from_port = 8
to_port = 0
}

egress {
protocol = -1
cidr_blocks = ["0.0.0.0/0"]
from_port = 0
to_port = 0
}
}

# Create private Security Group and specify in/out bound rules
resource "aws_security_group" "Ec2-private-SG" {
  vpc_id = aws_vpc.awslab-vpc.id
  name = "EC2-private-SG"
  description = "Ec2 instances private SG"
  dynamic "ingress" {
  for_each = var.ports_ec2_private
  iterator = port
  content {
    from_port = port.value
    to_port = port.value
    protocol = "tcp"
    cidr_blocks = ["172.16.1.0/24"]
    description = "Ec2 instances private SG"
  }
  }
  ingress {
protocol = "icmp"
cidr_blocks = ["172.16.1.0/24"]
from_port = 8
to_port = 0
}
}



# Creating EC2 instence for websrver public
# Install docker and docker compose using user_data
# Configure docker compose
# Expose binding the 80 port
resource "aws_instance" "webserver_public_4" {
    ami = "ami-06616b7884ac98cdd"
    instance_type = "t2.micro"
    key_name = "public"
    count = 1
    vpc_security_group_ids = [aws_security_group.Ec2-public-SG.id]
    subnet_id = aws_subnet.awslab-subnet-public.id
    associate_public_ip_address = true
    connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("~/Desktop/VPC/VPC_Task_Ayman/public.pem")
     host = aws_instance.webserver_public_4[0].public_ip
   }
   provisioner "remote-exec" {
     inline = [
        "sudo yum update -y",
        "sudo yum install -y docker",
        "sudo service docker start",
        "sudo usermod -a -G docker ec2-user",
        "sudo docker pull nginx:latest",
        "sudo docker run --name mynginx1 -p 80:80 -d nginx"
   ]
   }
    tags = {
        name = "public instance_4"
    }
}

# Creating EC2 instence for database private
resource "aws_instance" "webserver_private" {
    ami = "ami-06616b7884ac98cdd"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.Ec2-private-SG.id]
    subnet_id = aws_subnet.awslab-subnet-private.id
    count = 1
    tags = {
        name = "private instance"
    }
}