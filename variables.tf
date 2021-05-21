variable  "tf_spn_secret" {
    type        = string
    description = "SPN secret"
    sensitive   = true 
}
variable "tf_spn_secret_validity"{
    type        = string
    description = "SPN secret validity"
    default     = timeadd(timestamp(),"8760h")
}