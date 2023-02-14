# Base
resource "aws_vpc" "occult_orca" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "eked_echidna" {
  vpc_id = aws_vpc.occult_orca.id
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.occult_orca.id
  cidr_block              = element(var.private_subnets, count.index)
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.occult_orca.id
  cidr_block              = element(var.public_subnets, count.index)
}

# Routing
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.occult_orca.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eked_echidna.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "sassy_sukko" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_eip" "nat" {
  count      = length(var.private_subnets)
  vpc        = true
  depends_on = [aws_internet_gateway.eked_echidna]
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.occult_orca.id
}

resource "aws_route" "private" {
  count                  = length(var.private_subnets)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.sassy_sukko.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
