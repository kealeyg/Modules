module init {
    source = "github.com/hashicorp/example"
}

module iaas {
    source = "github.com/hashicorp/example"
    depends_on = [module.init]
}

