module "jenkins" {
  source  = "cn-terraform/jenkins/aws"
  version = "2.0.13"
  name_prefix = "jenkins" 
  region = "us-east-1"  
  private_subnets_ids = 
  public_subnets_ids =
  vpc_id =

}
