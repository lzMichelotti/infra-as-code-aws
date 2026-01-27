variable "default_tags" {
  type = object({
    Project     = string
    Environment = string
  })

  default = {
    Project     = "meu-projeto-devops"
    Environment = "production"
  }
}

variable "assume_role" {
  type = object({
    arn    = string
    region = string
  })

  default = {
    arn    = "arn:aws:iam::236510206699:role/workshop"
    region = "us-west-1"
  }
}

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name              = string
      cidr_block        = string
      availability_zone = string
    }))
    private_subnets = list(object({
      name              = string
      cidr_block        = string
      availability_zone = string
    }))
  })

  default = {
    name                     = "workshop-dvn-jan-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "workshop-dvn-jan-igw"
    nat_gateway_name         = "workshop-dvn-jan-ngw"
    public_route_table_name  = "workshop-dvn-jan-public-rt"
    private_route_table_name = "workshop-dvn-jan-private-rt"
    public_subnets = [{
      name              = "workshop-dvn-jan-vpc-public-subnet-us-west-1a"
      cidr_block        = "10.0.0.0/26"
      availability_zone = "us-west-1a"
      },
      {
        name              = "workshop-dvn-jan-vpc-public-subnet-us-west-1c"
        cidr_block        = "10.0.0.64/26"
        availability_zone = "us-west-1c"
    }]
    private_subnets = [{
      name              = "workshop-dvn-jan-vpc-private-subnet-us-west-1a"
      cidr_block        = "10.0.0.128/26"
      availability_zone = "us-west-1a"
      },
      {
        name              = "workshop-dvn-jan-vpc-private-subnet-us-west-1c"
        cidr_block        = "10.0.0.192/26"
        availability_zone = "us-west-1c"
    }]
  }
}
