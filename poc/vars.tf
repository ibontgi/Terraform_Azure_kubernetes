variable "location" {
    type        = string
    description = "Region de azure"
    default     = "West Europe"
}
variable "vm_size" {
    type        = string
    description = "tamaño de la MV"
    default     = "Standard_D2_v2"
}

variable "admin_user" {
    type        = string
    description = "nombre del usuario administrador"
    default     = "adminUser"
}

variable "admin_user_pass" {
    type        = string
    description = "contraseña del usuario administrador"
    default     = "Admin123"
}

variable "ansible_user" {
    type        = string
    description = "nombre del usuario Ansible"
    default     = "ansible"
}

variable "ansible_user_pass" {
    type        = string
    description = "contraseña del usuario Ansible"
    default     = "A1234567"
}