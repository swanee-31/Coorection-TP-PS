# Installer les outils de gestion des services de domaine Active Directory sur le serveur DC01
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Verbose
#La colonne Success affichera True une fois la barre de progression terminée. Le serveur possède les binaires, mais n'est pas encore un contrôleur de domaine. 

# Vérification :
 Get-WindowsFeature -Name AD-Domain-Services


