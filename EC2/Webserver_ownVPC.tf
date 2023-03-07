# CREATE PRIVATE KEY
resource "tls_private_key" "get_private_key" {
  algorithm = "RSA"
}
resource "local_file" "private_key" {
  filename = "/home/faizan/aws_keys/own_vpc.pem"
  content = tls_private_key.get_private_key.private_key_pem
}
resource "aws_key_pair" "public_key" {
  key_name = "own_vpc"
  public_key = tls_private_key.get_private_key.public_key_openssh
}

# CREATE EC2 Instance
resource "aws_instance" "webserver" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  key_name = aws_key_pair.public_key.key_name
  user_data = file("webserver.sh")
  subnet_id = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.webserver_sg.id ]
  tags = {
    "Name" = "Own VPC Webserver"
  }
}

# CREATE SECURITY GROUP
resource "aws_security_group" "webserver_sg" {
  name = "Own VPC SG"
  vpc_id = aws_vpc.webserver_vpc.id

  ingress{
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE VPC
# Path --> VPC -> Subnets(private/public) -> IG -> Route Table -> Associate Subnet with Route
# 1) Create VPC
resource "aws_vpc" "webserver_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "My Own VPC"
  }
}

# 2) Create Subnets with AZ
variable "azs" {
  type = list(string)
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}
variable "public_subnet_cidrs" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}
variable "private_subnet_cidrs" {
  type = list(string)
  default = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.webserver_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    "Name" = "Public Subnet - ${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.webserver_vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    "Name" = "Private Subnet - ${count.index + 1}"
  }
}

# 3) Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.webserver_vpc.id
  tags = {
    "Name" = "Own Internet Gateway"
  }
}

# 4) Create Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.webserver_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "Own Route Table"
  }
}

# 5) Subnet Association with Route Table
resource "aws_route_table_association" "subnet_asso" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.route_table.id
}

output "S1" {
  value = aws_subnet.public_subnet[0].id
}
output "S2" {
  value = aws_subnet.public_subnet[1].id
}
output "S3" {
  value = aws_subnet.public_subnet[2].id
}

data "aws_subnet" "get_subnet" {
    id = "subnet-01bd37c1bc59b888f"
}

output "getSub" {
  value = data.aws_subnet.get_subnet.vpc_id
}

/**Output of apply command. Reference to aws_subnet.public_subnet[*].id

aws_subnet.public_subnet[0]: Refreshing state... [id=subnet-0666b4dcfaeac98ad]
aws_subnet.public_subnet[2]: Refreshing state... [id=subnet-0d6aa2ad50c991578]
aws_subnet.private_subnet[1]: Refreshing state... [id=subnet-0377a555ba4e46c2b]
aws_internet_gateway.igw: Refreshing state... [id=igw-01bc0f767958e9f90]
aws_subnet.private_subnet[2]: Refreshing state... [id=subnet-053ad1c73f085174f]
aws_subnet.private_subnet[0]: Refreshing state... [id=subnet-09636d9b2b0d2e870]
aws_subnet.public_subnet[1]: Refreshing state... [id=subnet-01bd37c1bc59b888f]


**/