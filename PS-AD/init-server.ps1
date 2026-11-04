# script d'initialisation du serveur DC01 : renommer le serveur, configurer IP et DNS
# 1. Renommer le serveur
Rename-Computer -NewName "DC01"

# 2. Définir l'adresse IP statique (adaptez selon votre réseau Hyper-V)
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.1.10" -PrefixLength 24 -DefaultGateway "192.168.1.1"

# 3. Définir le serveur DNS (il se pointera lui-même une fois l'AD installé)
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "127.0.0.1"

# Redémarrer pour appliquer le nouveau nom
Restart-Computer
