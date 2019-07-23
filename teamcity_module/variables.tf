# required variables
variable "db_password" {
  type = string
}

# defaulted variables
variable "db_name" {
  default = "teamcity"
}

variable "db_username" {
  default = "teamcityuser"
}

variable "key_name" {
  default = "teamcity"
}

variable "ssh_path" {
  default = "~/.ssh"
}

variable "unique_s3_name" {
  type = string
}

variable "vpc_id" {
  type = string
}
