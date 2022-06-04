module "test" {
  source      = "../"
  name_prefix = "test"
  vpc_cidr    = "10.17.0.0/20"
  natgateway  = ["a", "b", "c"]
  public_subnets = {
    a = "10.17.0.0/23"
    b = "10.17.2.0/23"
    c = "10.17.4.0/23"
  }
  private_subnets = {
    a = "10.17.6.0/23"
    b = "10.17.8.0/23"
    c = "10.17.10.0/23"
  }
}

output "public-subnet-ids" {
  value = [ for k,v in module.test.public-subnet-ids: v]
}
output "a-private-subnet-id" {
  value = module.test.private-subnet-ids["a"]
}
