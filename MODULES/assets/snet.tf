# Definitions
#-----------------------------------------------------------------------------------------#
variable "snet" {
  default = {
    dev = {}
    prod = {}
    core = {
      external = "ScPcCNR-Core-External-snet"
    }
    maz = {}
    sandbox = {
      app = "ScDcCNR-Dev-App-snet"
    }
  }
}

# Outputs
#-----------------------------------------------------------------------------------------#
output "snet" {value = var.snet}