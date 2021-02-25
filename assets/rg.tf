# Definitions
#-----------------------------------------------------------------------------------------#
variable "rg" {
  default = {
    dev = {}
    prod = {}
    core = {
      network = "ScPc-Network_Core-rg"
      system = "ScPc-System_Core-rg"
      security = ""
      keyvault = ""
      log = "ScPc-LogAnalytics_Core-rg"
    }
    sandbox = {
      network = "ScDc-Network_Dev-rg"
      system = "ScDc-System_Dev-rg"
      security = ""
      log = "ScSc-LogAnalytics_Core-rg"
    }
    maz = {}
  }
}

# Outputs
#-----------------------------------------------------------------------------------------#
output "rg" {value = var.rg}
