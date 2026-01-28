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

variable "eks_cluster" {
  type = object({
    name                                   = string
    version                                = string
    access_config_authentication_mode      = string
    node_group_name                        = string
    node_group_capacity_type               = string
    node_group_instance_types              = list(string)
    node_group_scaling_config_desired_size = number
    node_group_scaling_config_max_size     = number
    node_group_scaling_config_min_size     = number
  })

  default = {
    name                                   = "dvn-workshop-jan-eks-cluster"
    version                                = "1.31"
    access_config_authentication_mode      = "API_AND_CONFIG_MAP"
    node_group_name                        = "dvn-workshop-jan-eks-cluster-ng"
    node_group_capacity_type               = "ON_DEMAND"
    node_group_instance_types              = ["t2.micro"]
    node_group_scaling_config_desired_size = 2
    node_group_scaling_config_max_size     = 2
    node_group_scaling_config_min_size     = 2
  }
}
