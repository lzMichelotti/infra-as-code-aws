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

variable "remote_backend" {
  type = object({
    dynamo_table_name          = string
    dynamo_table_billing_mode  = string
    dynamo_table_hash_key      = string
    dynamo_table_hash_key_type = string
    bucket_name                = string
  })

  default = {
    dynamo_table_name          = "meu-projeto-devops-tfstate-lock"
    dynamo_table_billing_mode  = "PAY_PER_REQUEST"
    dynamo_table_hash_key      = "LockID"
    dynamo_table_hash_key_type = "S"
    bucket_name                = "meu-projeto-devops-tfstate"
  }
}
