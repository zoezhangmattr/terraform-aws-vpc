# terraform-aws-vpc

## overview
a light terraform module to create a vpc with 3 private subnets, 3 public subnets, 1 gateway, 3 nat gateway.

## usage
see example folder.
```tf
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
```

## input
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | a name prefix used to tag vpc | `string` | true | yes |
| vpc_cidr | vpc cidr block | `string` | false | yes |
| public_subnets | public subnets map, availability zone map to cidr block | `map` | false | yes |
| extra_public_subnet_tags | extra tags to add to public subnet | `map` | false | false |
| private_subnets | private subnets map, availability zone map to cidr block | `map` | false | yes |
| extra_private_subnet_tags | extra tags to add to private subnet | `map` | false | false |
| natgateway | nat gateway list of availability zone to spread | `list` | false | yes |

## output
| Name | Description | Type |
|------|-------------|------|
| vpc-id | the vpc id | string |
| public-subnet-ids | a map of generated public subnet ids| map |
| private-subnet-ids | a map of generated private subnet ids| map|
