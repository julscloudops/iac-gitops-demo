resource "aws_vpc_peering_connection" "eks_elastic_peering" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.elastic_kibana_vpc 
  vpc_id        = var.eks_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between the EKS and ELASTIC/KIBANA VPCs"
  }
}


