variable "region" {
  description = "The region the environment is going to be installed into"
  type        = string
  default     = "us-east-1"
}

# VPC variables

variable "vpc_cidr" {
  description = "CIDR range of VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "task_container_environment_custom" {
  description = "The environment variables to pass to a container."
  default     = {
    "DEBUG": "TRUE",
    "SECRET_KEY": "sj4dfez5hz6bxqa1w&k@(h=ej_$xu7mzm_83(pl$2o0i6o48y-",
    "DATABASE_URL": "postgres://postgresql:java123456789@hirecoderdbdevelop.coemjfchnzgt.us-east-1.rds.amazonaws.com/hirecoder"
  }
  type        = map(string)
}
