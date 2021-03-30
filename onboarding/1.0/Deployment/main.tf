module init {
    source = "https://github.com/kealeyg/Modules/blob/5a0d7f30cef665c7687bd00147235339129945ba/onboarding/1.0/Modules/init/"
}

module iaas {
    source = "https://github.com/kealeyg/Modules/blob/5a0d7f30cef665c7687bd00147235339129945ba/onboarding/1.0/Modules/iaas/"
    depends_on = [module.init]
}

