# Installer les outils d'administration à distance du serveur (RSAT) pour Active Directory
# ce script doit être lancé en tant qu'administrateur
# prend un certain temps...

Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0" 

# pour installer tous les outils RSAT disponibles : 
# Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory~~~~0.0.1.0"

# lister tous les RSATs disponibles :
Get-WindowsCapability -Online -Name "Rsat*"

# lister les RSATs installés :
Get-WindowsCapability -Online | Where-Object Name -like "Rsat*" | Where-Object State -eq "Installed"

