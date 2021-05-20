locals {
  region                    = "eu-central-1"
  availability_zone_count   = 2
  vpc_cidr_block            = "10.10.0.0/16"
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
  tags = {
    "Environment" = "fis-test"
  }
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}
