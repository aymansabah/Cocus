
# Create vpc 
resource "aws_vpc" "awslab-vpc" {
  cidr_block              = "172.16.0.0/16"
  instance_tenancy        = "default"
  enable_dns_hostnames    = "1"
  tags      = {
    Name    = "awslab-vpc"
  }
}

# Create Public Subnet 
resource "aws_subnet" "awslab-subnet-public" {
  vpc_id                  = aws_vpc.awslab-vpc.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = "true"

  tags      = {
    Name    = "awslab-subnet-public"
  }
}

# Create Private Subnet 
resource "aws_subnet" "awslab-subnet-private" {
  vpc_id                   = aws_vpc.awslab-vpc.id
  cidr_block               = "172.16.2.0/24"
  availability_zone        = "eu-central-1b"
  map_public_ip_on_launch  = "false"

  tags      = {
    Name    = "awslab-subnet-private"
  }
}


# Create Internet Gateway and Attach it to the VPC
resource "aws_internet_gateway" "awslab-GW-internet" {
  vpc_id    = aws_vpc.awslab-vpc.id
  tags      = {
    Name    = "awslab-GW-internet"
  }
}

# Create Public Route Table 
resource "aws_route_table" "awslab-rt-internet" {
  vpc_id       =  aws_vpc.awslab-vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awslab-GW-internet.id
  }

  tags       = {
    Name     = "awslab-rt-internet"
  }
}


# Create association with Public subnet using the RT
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.awslab-subnet-public.id
  route_table_id = aws_route_table.awslab-rt-internet.id
}
