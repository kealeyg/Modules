# Definitions
#-----------------------------------------------------------------------------------------#
variable "globals" {
  default = {
    tags = {
      env="sandbox"
      costcenter="816231"
      classification="ull"
      owner="jacqueline.morcos@canada.ca"
      contact="Gregory.Kealey@canada.ca"
      deployment="azure-lz-iac-2020-05-27"
    }
    prefix = {
      department = "Sc"
      environment = {
        dev = "D"
        prod = "P"
        core = "C"
        sand = "S"
      }
      region = {
        canadaCentral = "c"
      }
    }
    user = "admkealeyg"
    password = "Canada1!"
  }
}

# Outputs
#-----------------------------------------------------------------------------------------#
output "globals" {value = var.globals}