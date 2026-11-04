# Définition du mot de passe de restauration des services d'annuaire (DSRM)
$pwd = ConvertTo-SecureString "P@ssw0rd2026!" -AsPlainText -Force

# Promotion du serveur (la commande redémarrera le serveur à la fin)
Install-ADDSForest -DomainName "lab.local" -SafeModeAdministratorPassword $pwd -InstallDns -Force 

# Le serveur va redémarrer de lui-même. À l'écran de connexion, vous verrez que vous vous connectez désormais au domaine (ex: LAB\Administrateur). 
