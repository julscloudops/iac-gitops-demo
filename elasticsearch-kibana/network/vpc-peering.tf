# Gets the data of the EKS in order to establish VPC-Peering

data "aws_vpc" "eks_vpc" {
  tags = {
    "name" = "eks-vpc"
  }
}

resource "aws_vpc_peering_connection" "eks_elastic_peering" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.elastic_kibana_vpc.id 
  vpc_id        = data.aws_vpc.eks_vpc.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between the EKS and Elastic/Kibana VPCs"
  }
}

resource "aws_route" "eks_to_elastic" {
  #I don't know if this will work
    route_table_id = data.aws_vpc.eks_vpc.main_route_table_id
    destination_cidr_block = "10.100.2.0/24"
    vpc_peering_connection_id  = aws_vpc_peering_connection.eks_elastic_peering.id
}

resource "aws_route" "elastic_to_eks" {
    route_table_id = aws_route_table.elk_route.id
    destination_cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id  = aws_vpc_peering_connection.eks_elastic_peering.id
}


