resource "aws_vpc" "vpcnew" {
  cidr_block = var.VPC_CIDR

  tags = {
    Name = "asg_vpc"
  }
}

resource "aws_subnet" "subnets" {
    count             = 2
    vpc_id            = aws_vpc.vpcnew.id
    cidr_block        = cidrsubnet(var.VPC_CIDR, 8, count.index)
    availability_zone = var.AVAILABILITY_ZONE_NAMES[count.index]

    tags = {
        Name = var.SUBNET_TAGNAMES[count.index]
    }
    depends_on = [
      aws_vpc.vpcnew
    ]

}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpcnew.id

  tags = {
    Name = "igw"
  }
  depends_on = [
    aws_vpc.vpcnew,
    aws_subnet.subnets
  ]
}

resource "aws_route_table" "routetables" {
  count     =  2
  vpc_id    = aws_vpc.vpcnew.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.ROUTE_NAMES[count.index]
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table_association" "associate_rote" {
    subnet_id      = aws_subnet.subnets[0].id
    route_table_id = aws_route_table.routetables[0].id

    depends_on = [
      aws_route_table.routetables
    ]
 
}


resource "aws_security_group" "instance_security" {
  description = "This is for info.php"
   vpc_id = aws_vpc.vpcnew.id
  
  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress  {
    from_port    =  0
    to_port      =  0
    protocol     = "-1"
    cidr_blocks  = [ "0.0.0.0/0" ]
  }
  name   = "securityfornodejs"

  depends_on = [
    aws_route_table_association.associate_rote
  ]

}
