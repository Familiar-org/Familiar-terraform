# NAT GW
resource "aws_nat_gateway" "ngw" {
  subnet_id     = var.pri_subnet_id
  allocation_id = aws_eip.ngw.id
  tags = {
    Name = "${var.prefix}-nat-gw"
  }
}

# eip

resource "aws_eip" "ngw" {

  tags = {
    Name = "${var.prefix}-nat-eip"
  }
}
