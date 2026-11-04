# Définir la date de naissance
$DateNaissance = [System.DateTime]::new(1906, 6, 9)

# Récupérer la date d'aujourd'hui
$DateAujourdhui = [System.DateTime]::Today

# Calculer la différence entre aujourd'hui et la date de naissance
$Difference = $DateAujourdhui - $DateNaissance 
# surcharge de l'opérateur -

# Afficher les résultats
Write-Host "Date de naissance : $($DateNaissance.ToShortDateString())"
Write-Host "Date d'aujourd'hui : $($DateAujourdhui.ToShortDateString())"
Write-Host "Nombre de jours depuis votre naissance : $([int]$Difference.TotalDays) jours"
