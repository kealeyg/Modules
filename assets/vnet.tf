# Definitions
#-----------------------------------------------------------------------------------------#
variable "vnet" {
  default = {
    dev = {}
    prod = {}
    core = {
      prod = "ScPcCNR-Core-vnet"
    }
    maz = {}
    sandbox = {
      dev = "ScDcCNR-Dev-vnet"
    }
  }
}

# Outputs
#-----------------------------------------------------------------------------------------#
output "vnet" {value = var.vnet}