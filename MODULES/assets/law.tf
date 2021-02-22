# Definitions
#-----------------------------------------------------------------------------------------#
variable "law" {
  default = {
      coreSecurity = ""
      coreHealth = ""
      coreUpdate = "ScSc-UpdMgr-law"
  }
}

# Outputs
#-----------------------------------------------------------------------------------------#
output "law" {value = var.law}