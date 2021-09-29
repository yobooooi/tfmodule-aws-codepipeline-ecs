locals { 
  default_tags = {
    "Owner"       = var.team
    "ManagedBy"   = "terraform"
    "Service"     = var.service
    "Backup"      = "false"
    "Status"      = "active"
  }
}
